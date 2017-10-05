# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupNotificationPresenter do
  let(:competitor) { create(:competitor, :with_link) }
  let(:group) { competitor.group }
  subject { GroupNotificationPresenter.new(group) }

  describe '#latest_data' do
    context 'when first extraction from amazon is made' do
      before do
        # Simulate first extraction from amazon
        competitor.update_attributes(
          price_low: 1.0,
          price_high: 2.0,
          title: 'Other Title',
          images: %w[img1 img2],
          features: "Feature1\nFeature2",
          number_of_reviews: 100,
          best_seller_rank: 50,
          inventory: 250
        )
      end

      it 'generates the hash only showing changes' do
        result_hash = {
          name: group.name,
          competitors: [
            {
              name: competitor.name,
              changes: {
                price_low: [nil, 0.1e1],
                price_high: [nil, 0.2e1],
                title: [nil, 'Other Title'],
                images: [[], %w[img1 img2]],
                features: [nil, "Feature1\nFeature2"],
                number_of_reviews: [nil, 100],
                best_seller_rank: [nil, 50],
                inventory: [nil, 250]
              }.with_indifferent_access
            }.with_indifferent_access
          ]
        }.with_indifferent_access
        expect(subject.latest_data).to match(result_hash)
      end

      context 'when second extraction from amazon is made' do
        before do
          # Simulate first extraction from amazon
          competitor.update_attributes(
            price_low: 2.0,
            price_high: 3.0,
            inventory: 100
          )
        end

        it 'generates the hash only showing changes' do
          result_hash = {
            name: group.name,
            competitors: [
              {
                name: competitor.name,
                changes: {
                  price_low: [0.1e1, 0.2e1],
                  price_high: [0.2e1, 0.3e1],
                  inventory: [250, 100]
                }.with_indifferent_access
              }.with_indifferent_access
            ]
          }.with_indifferent_access
          expect(subject.latest_data).to match(result_hash)
        end
      end
    end
  end
end
