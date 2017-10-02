# frozen_string_literal: true

require 'rails_helper'
$LOAD_PATH << '../lib'
require 'amazon/exceptions'

RSpec.describe CompetitorMonitorDecorator do
  context 'when extracts data from amazon' do
    let(:competitor) do
      create(:competitor, link: 'https://www.amazon.com/dp/B00ZLJ1QGC')
    end

    before do
      allow_any_instance_of(Amazon::Scraper).to receive(:fetch)
        .with(competitor.link).and_return(
          price_low: 110.5,
          price_high: 210.5,
          title: 'Some Title',
          images: %w[http://image-link1.jpg http://image-link2.jpg],
          features: 'Some long text\nwith new lines in the middle',
          number_of_reviews: 100,
          best_seller_rank: 1010,
          inventory: 55
        )
      CompetitorMonitorDecorator.new(competitor).save
    end

    it 'records price in competitor' do
      expect(competitor.price_low).to eq(110.5)
      expect(competitor.price_high).to eq(210.5)
    end

    it 'records title in competitor' do
      expect(competitor.title).to eq('Some Title')
    end

    it 'records images in competitor' do
      expect(competitor.images).to match_array(
        %w[http://image-link1.jpg http://image-link2.jpg]
      )
    end

    it 'records features in competitor' do
      expect(competitor.features).to eq('Some long text\nwith new lines '\
                                        'in the middle')
    end

    it 'records number of reviews in competitor' do
      expect(competitor.number_of_reviews).to eq(100)
    end

    it 'records best seller rank in competitor' do
      expect(competitor.best_seller_rank).to eq(1010)
    end

    it 'records inventory in competitor' do
      expect(competitor.inventory).to eq(55)
    end
  end
end
