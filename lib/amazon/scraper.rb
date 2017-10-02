# frozen_string_literal: true

require 'amazon/exceptions'

# Add some conversion helpers for scraping strings
class String
  def currency_to_array_price
    to_s.split(' - ').map { |price| price.gsub(/[$,]/, '').to_f }
  end

  def remove_html_spaces
    gsub(/[ \t\n]+/, ' ').strip
  end

  def rank_to_i
    self[/#[\d,]+/].gsub(/[#,]/, '').to_i
  end
end

# Amazon module
module Amazon
  # Amazon Scraper for product data
  class Scraper
    def initialize
      @agent = Mechanize.new
      @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @agent.open_timeout = 10
      @agent.read_timeout = 10
      @agent.retry_change_requests = true
      @agent.user_agent_alias = 'Linux Firefox'
      # can't comply to robots.txt because it's not allowed to scrape some
      # of the pages involved
      # @agent.robots = true
      # to simulate human clicks and avoid robot detection
      # @agent.history_added = Proc.new { sleep 0.5 }
    end

    def fetch(product_link)
      handle_exceptions do
        result = {}
        product_page = @agent.get(product_link)
        result.merge(ProductPageScraper.new(product_page).product_data)
              .merge(ProductStockScraper.new(@agent, product_page).stock_data)
      end
    end

    private

    def handle_exceptions
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout, Net::HTTP::Persistent::Error
      raise CommunicationError, 'Connection Timed Out'
    rescue Mechanize::ResponseCodeError
      raise ProductNotFoundError, 'Link provided for product returns 404'
    rescue StandardError
      # TODO: log exception
      raise ParseError, 'Some error occurred while parsing data'
    end
  end

  # Product stock scraper
  class ProductStockScraper
    def initialize(agent, product_page)
      add_item_page = product_page.form_with(id: 'addToCart').submit
      @cart_form = if add_item_page.search('a#hlb-view-cart-announce').any?
                     update_cart_page = agent.click(
                       add_item_page.link_with(id: 'hlb-view-cart-announce')
                     )
                     update_cart_page.form(id: 'activeCartViewForm')
                   end
    end

    def stock_data
      updated_stock_page = update_cart_stock_to_max
      data = {}
      data[:inventory] =
        if updated_stock_page
          update_cart_stock_to_max.search(
            'form#activeCartViewForm div.sc-list-item-content '\
            'input[name^="quantity."]'
          ).attr('value').value.to_i
        end
      data
    end

    private

    def update_cart_stock_to_max
      return unless @cart_form
      qty_field = @cart_form.field_with(name: /quantity\./)
      qty_field.value = 999
      submit_btn = @cart_form.button_with(name: 'submit.update')
      @cart_form.submit(submit_btn)
    end
  end

  # Product detail page scraper
  class ProductPageScraper
    def initialize(page)
      @page = page
    end

    def product_data
      p_data = {}
      [method(:price), method(:title), method(:images), method(:features),
       method(:reviews), method(:seller_rank)].each do |method|
        p_data.merge!(method.call)
      end
      p_data
    end

    private

    def price
      price_array = @page.search('span#priceblock_ourprice').text
                         .currency_to_array_price
      price_low = price_array[0]
      price_high = price_array.size > 1 ? price_array[1] : price_low
      { price_low: price_low, price_high: price_high }
    end

    def title
      { title: @page.search('span#productTitle').text.remove_html_spaces }
    end

    def images
      { images: @page.search('div#altImages li.a-spacing-small.item img')
                     .map { |img| img.attr('src') } }
    end

    def features
      { features: @page.search(
        'div#feature-bullets li:not(#replacementPartsFitmentBullet) '\
        'span.a-list-item'
      ).map { |feature| feature.text.remove_html_spaces }.join("\n") }
    end

    def reviews
      { number_of_reviews: @page.search('span#acrCustomerReviewText')
                                .text.to_i }
    end

    def seller_rank
      { best_seller_rank: @page.search('div#detail-bullets li#SalesRank')
                               .text.rank_to_i }
    end
  end
end
