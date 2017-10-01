# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitorHelper, type: :helper do
  describe '#asin_to_link' do
    let(:some_asin) { Faker::Code.asin }
    it 'displays html for menu items with links' do
      expect(helper.asin_to_link(some_asin)).to eq(
        "https://www.amazon.com/dp/#{some_asin}"
      )
    end
  end
end
