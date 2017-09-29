require 'rails_helper'

RSpec.describe Competitor, type: :model do
  describe 'Validations' do
    context 'when record has link and no asin' do
      subject { build(:competitor, :with_link) }

      it 'is valid with valid attributes' do
        is_expected.to be_valid
      end

      it 'is not valid with invalid link format' do
        subject.link = 'http:'
        is_expected.to_not be_valid
      end
    end

    context 'when record has asin and no link' do
      subject { build(:competitor, :with_asin) }

      it 'is valid with valid attributes' do
        is_expected.to be_valid
      end

      it 'is not valid with invalid product asin format' do
        subject.product_asin = '1234'
        is_expected.to_not be_valid
      end
    end

    it 'is not valid if both link and product_asin are not present' do
      expect(build(:competitor)).to_not be_valid
    end

    it 'is not valid if both link and product_asin are present' do
      expect(build(:competitor, :with_asin, :with_link)).to_not be_valid
    end
  end

  describe 'Associations' do
    it 'belongs to a group' do
      assoc = described_class.reflect_on_association(:group)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
