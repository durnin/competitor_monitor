# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'when maximum number of groups has been reached' do
    before do
      described_class::MAX_NUMBER_OF_GROUPS.times { create(:group) }
    end

    it 'is not valid to create a new group' do
      expect(build(:group)).to_not be_valid
    end
  end

  context 'when groups count is one away from maximum' do
    before do
      (described_class::MAX_NUMBER_OF_GROUPS - 1).times { create(:group) }
    end

    it 'is valid to create a new group' do
      expect(build(:group)).to be_valid
    end
  end
end
