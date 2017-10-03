# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competitor, type: :model, paper_trail: true do
  describe 'Validations' do
    def self.test_format_attribute(att_name, att_trait, att_invalid_val)
      context "when record has #{att_name}" do
        subject { build(:competitor, att_trait) }

        it 'is valid with valid attributes' do
          is_expected.to be_valid
        end

        it 'is not valid with invalid link format' do
          subject[att_name] = att_invalid_val
          is_expected.to_not be_valid
        end
      end
    end

    test_format_attribute('link', :with_link, 'http:')
    test_format_attribute('product_asin', :with_asin, '1234')

    it 'is not valid if both link and product_asin are not present' do
      expect(build(:competitor)).to_not be_valid
    end

    it 'is not valid if both link and product_asin are present' do
      expect(build(:competitor, :with_asin, :with_link)).to_not be_valid
    end

    context 'when maximum number of competitors has been reached' do
      let(:group_with_competitors) do
        create(:group, :with_competitors,
               competitors_count: described_class::MAX_NUMBER_OF_COMPETITORS)
      end

      it 'is not valid to create a new competitor' do
        expect(build(:competitor, :with_link,
                     group: group_with_competitors)).to_not be_valid
      end
    end

    context 'when competitors count is one away from maximum' do
      let(:group_with_competitors) do
        create(:group, :with_competitors,
               competitors_count:
                   described_class::MAX_NUMBER_OF_COMPETITORS - 1)
      end

      it 'is valid to create a new competitor' do
        expect(build(:competitor, :with_link,
                     group: group_with_competitors)).to be_valid
      end
    end
  end

  test_simple_association(:group, :belongs_to)

  it { is_expected.to be_versioned }

  context 'when updating to check versioning', versioning: true do
    subject { create(:competitor, :with_asin) }
    before do
      subject.update_attributes!(name: 'Competitor 1',
                                 product_asin: 'B012321355')
      subject.update_attributes!(price_low: 1.0, price_high: 10.0)
      subject.update_attributes!(title: 'Some Title',
                                 features: 'Some features')
      subject.update_attributes!(number_of_reviews: 20,
                                 best_seller_rank: 100,
                                 inventory: 50)
      subject.update_attributes!(images: %w[image1 image2])
    end

    it { is_expected.to_not have_a_version_with_changes(name: 'Competitor 1') }
    it do
      is_expected.to_not have_a_version_with_changes(
        product_asin: 'B012321355'
      )
    end
    it { is_expected.to have_a_version_with_changes title: 'Some Title' }
    it { is_expected.to have_a_version_with_changes features: 'Some features' }
    it do
      is_expected.to have_a_version_with_changes(
        number_of_reviews: 20, best_seller_rank: 100, inventory: 50
      )
    end
  end
end
