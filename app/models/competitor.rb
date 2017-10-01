# frozen_string_literal: true

# Competitors model
class Competitor < ApplicationRecord
  # CONSTANTS
  MAX_NUMBER_OF_COMPETITORS = 8

  # ATTRIBUTES
  # name
  # link
  # product_asin

  # ASSOCIATIONS
  belongs_to :group, inverse_of: :competitors

  # VALIDATIONS
  validates :link, url: { allow_blank: true, no_local: true }
  validates :link, presence: true, unless: Proc.new do |competitor|
    competitor.product_asin.present?
  end
  validates :product_asin, format: { with: /\A[\dA-Z]{9}|\d{9}(X|\d)\z/,
                                     message: 'only allows ASIN format' },
                           allow_blank: true
  validates :product_asin, presence: true, unless: Proc.new do |competitor|
    competitor.link.present?
  end
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
