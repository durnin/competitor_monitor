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
    rescue StandardError => error
      Rails.logger.error("Amazon::ParseError due to #{error.message}")
      raise ParseError, 'Some error occurred while parsing data'
    end
  end

  # Product stock scraper
  class ProductStockScraper
    ADD_TO_CART_FORM_ID = 'addToCart'
    UPDATE_CART_LINK_ID = 'hlb-view-cart-announce'
    SELECTOR_UPDATE_CART_LINK = "a##{UPDATE_CART_LINK_ID}"
    UPDATE_CART_FORM_ID = 'activeCartViewForm'
    QUANTITY_FIELD_NAME_REGEX = /quantity\./
    UPDATE_CART_SUBMIT_BTN_NAME = 'submit.update'
    SELECTOR_QUANTITY_FIELD =
      'form#activeCartViewForm div.sc-list-item-content '\
      'input[name^="quantity."]'

    def initialize(agent, product_page)
      add_item_page = product_page.form_with(id: ADD_TO_CART_FORM_ID).submit
      @cart_form = if add_item_page.search(SELECTOR_UPDATE_CART_LINK).any?
                     update_cart_page = agent.click(
                       add_item_page.link_with(id: UPDATE_CART_LINK_ID)
                     )
                     update_cart_page.form(id: UPDATE_CART_FORM_ID)
                   end
    end

    def stock_data
      updated_stock_page = update_cart_stock_to_max
      data = {}
      data[:inventory] =
        if updated_stock_page
          update_cart_stock_to_max.search(SELECTOR_QUANTITY_FIELD)
                                  .attr('value').value.to_i
        end
      data
    end

    private

    def update_cart_stock_to_max
      return unless @cart_form
      qty_field = @cart_form.field_with(name: QUANTITY_FIELD_NAME_REGEX)
      qty_field.value = 999
      submit_btn = @cart_form.button_with(name: UPDATE_CART_SUBMIT_BTN_NAME)
      @cart_form.submit(submit_btn)
    end
  end

  # Product detail page scraper
  class ProductPageScraper
    SELECTOR_PRICE = 'span#priceblock_ourprice, span#priceblock_saleprice, '\
                     'span#priceblock_dealprice'
    SELECTOR_TITLE = 'span#productTitle'
    SELECTOR_IMAGES = 'div#altImages li.a-spacing-small.item img'
    SELECTOR_FEATURES =
      'div#feature-bullets li:not(#replacementPartsFitmentBullet)'\
      ' span.a-list-item'
    SELECTOR_REVIEWS = 'span#acrCustomerReviewText'
    SELECTOR_SELLER_RANK =
      'div#detail-bullets li#SalesRank, table#productDetails_'\
      'detailBullets_sections1 tr>td>span>span:first-child'

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
      price_array = @page.search(SELECTOR_PRICE).text.currency_to_array_price
      price_low = price_array[0]
      price_high = price_array.size > 1 ? price_array[1] : price_low
      { price_low: price_low, price_high: price_high }
    end

    def title
      { title: @page.search(SELECTOR_TITLE).text.remove_html_spaces }
    end

    def images
      { images: @page.search(SELECTOR_IMAGES)
                     .map { |img| img.attr('src') }
                     .sort }
    end

    def features
      { features: @page.search(SELECTOR_FEATURES)
                       .map do |feature|
                         feature.text.remove_html_spaces
                       end.sort.join("\n") }
    end

    def reviews
      { number_of_reviews: @page.search(SELECTOR_REVIEWS)
                                .text.delete(',').to_i }
    end

    def seller_rank
      seller_rank_elem = @page.search(SELECTOR_SELLER_RANK)
      if seller_rank_elem.any?
        { best_seller_rank: seller_rank_elem.text.rank_to_i }
      else
        {}
      end
    end
  end
end
