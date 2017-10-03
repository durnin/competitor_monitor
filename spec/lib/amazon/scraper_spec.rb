# frozen_string_literal: true

require 'rails_helper'

# Amazon module
module Amazon
  RSpec.describe Scraper do
    describe '#fetch' do
      def self.test_existing_product(context_txt, link, result_replacements)
        context "when fetching data for an existing #{context_txt}" do
          let(:result_hash) do
            {
              price_low: 73.07,
              price_high: 73.07,
              title: 'Easton S400 3 BBCOR Adult Baseball Bat',
              images: [
                'https://images-na.ssl-images-amazon.com/images/I/'\
                '31atFOoU%2BuL._SS40_.jpg'
              ],
              features: "Bbcor certified\nDurable aluminum alloy\n"\
                        'Thin 31/32 inch',
              number_of_reviews: 32,
              best_seller_rank: 160_836,
              inventory: 166
            }.merge!(result_replacements)
          end
          subject do
            amazon_scraper.fetch(link)
          end

          before do
            VCR.insert_cassette "amazon_existing_#{context_txt.underscore}",
                                record: :once#, re_record_interval: 7.days
          end

          after do
            VCR.eject_cassette
          end

          it { is_expected.to be_a(Hash) }
          it { is_expected.to match(result_hash) }
        end
      end

      let(:amazon_scraper) { Amazon::Scraper.new }

      test_existing_product('product',
                            'https://www.amazon.com/dp/B00ZLJ1NCY?th=1&psc=1',
                            {})
      test_existing_product('product with options',
                            'https://www.amazon.com/dp/B00ZLJ1NCY',
                            price_low: 64.21,
                            price_high: 99.99,
                            features: "-3 Weight Differential\n2-5/8\" Barrel"\
                            " Diameter\nBBCOR Certified\nDurable aluminum "\
                            "alloy\nThin 31/32\" tapered handle with "\
                            'pro tack grip',
                            best_seller_rank: 163_218,
                            inventory: nil)

      context 'when fetching data for no existing product' do
        subject do
          amazon_scraper.fetch('https://www.amazon.com/dp/B001234567')
        end

        before do
          VCR.insert_cassette 'amazon_no_existing_product', record: :once
        end

        after do
          VCR.eject_cassette
        end

        it 'raises an error' do
          expect { subject }.to raise_error(
            Amazon::ProductNotFoundError,
            'Link provided for product returns 404'
          )
        end
      end

      context 'when fetching data for incorrect link' do
        subject do
          amazon_scraper.fetch('https://www.google.com')
        end

        before do
          VCR.insert_cassette 'amazon_incorrect_link', record: :once
        end

        after do
          VCR.eject_cassette
        end

        it 'raises an error' do
          expect { subject }.to raise_error(
            Amazon::ParseError,
            'Some error occurred while parsing data'
          )
        end
      end

      context 'when amazon times out' do
        subject { amazon_scraper.fetch('https://www.amazon.com/dp/B001234567') }

        before do
          stub_request(:any, /www.amazon.com/).to_timeout
        end

        it 'raises an error' do
          expect { subject }.to raise_error(
            Amazon::CommunicationError,
            'Connection Timed Out'
          )
        end
      end

    end
  end
end
