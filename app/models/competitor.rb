# frozen_string_literal: true

# Competitors model
class Competitor < ApplicationRecord
  has_paper_trail skip: %i[name link product_asin]

  # CONSTANTS
  MAX_NUMBER_OF_COMPETITORS = 8

  # ATTRIBUTES
  # name
  # link
  # product_asin
  # price_low
  # price_high
  # title
  serialize :images, Array
  # features
  # number_of_reviews
  # best_seller_rank
  # inventory


  # ASSOCIATIONS
  belongs_to :group, inverse_of: :competitors

  # VALIDATIONS
  validates :link, url: { allow_blank: true, no_local: true }
  validates :link, presence: true, unless: lambda { |competitor|
    competitor.product_asin.present?
  }
  validates :product_asin, format: { with: /\A[\dA-Z]{9}|\d{9}(X|\d)\z/,
                                     message: 'only allows ASIN format' },
                           allow_blank: true
  validates :product_asin, presence: true, unless: lambda { |competitor|
    competitor.link.present?
  }
  validate :asin_link_simultaneous_presence
  validate :max_competitors_have_not_been_reached, on: :create

  private

  def asin_link_simultaneous_presence
    return unless product_asin.present? && link.present?
    errors[:base] << "ASIN and link can't be present at the same time"
  end

  def max_competitors_have_not_been_reached
    return if group.competitors.count < MAX_NUMBER_OF_COMPETITORS
    errors[:base] << 'maximum competitors have been reached for the '\
                     'group'
  end
end
