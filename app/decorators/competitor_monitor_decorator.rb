# frozen_string_literal: true

$LOAD_PATH << '../lib'
require 'amazon/exceptions'

# Decorator class to record competitor data from Amazon
class CompetitorMonitorDecorator
  include CompetitorHelper

  AMAZON_ERRORS = [
    Amazon::CommunicationError,
    Amazon::ProductNotFoundError,
    Amazon::ParseError
  ].freeze

  def initialize(competitor)
    @competitor = competitor
  end

  def save
    scraped_data = fetch_data.merge(updated_at: Time.now)
    # Ensure that no matter what competitor gets updated
    # so that it generates a new version
    @competitor.update_attributes(scraped_data)
  end

  private

  def fetch_data
    amazon_client = Amazon::Scraper.new
    link = if @competitor.link?
             @competitor.link
           else
             asin_to_link(@competitor.product_asin)
           end
    amazon_client.fetch(link)
  rescue *AMAZON_ERRORS => error
    Rails.logger.error(error.message)
    {}
  end
end
