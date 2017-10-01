# frozen_string_literal: true

# Competitor view helper
module CompetitorHelper
  def asin_to_link(asin)
    "https://www.amazon.com/dp/#{asin}"
  end
end
