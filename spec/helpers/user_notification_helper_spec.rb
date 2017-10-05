# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserNotificationHelper, type: :helper do
  describe '#last_notification' do
    def self.test_groups_with_changes(context_txt, competitors2, result_size)
      context context_txt do
        let(:group_presenter1) { instance_double(GroupNotificationPresenter) }
        let(:group_presenter2) { instance_double(GroupNotificationPresenter) }
        let(:latest_data_1) { { name: 'Group1', competitors: [1, 2] } }
        let(:latest_data_2) { { name: 'Group2', competitors: competitors2 } }
        let(:result) { [latest_data_1, latest_data_2][0..(result_size - 1)] }
        before do
          allow(Group).to receive(:find_each).and_yield(group1)
                                             .and_yield(group2)
          allow(GroupNotificationPresenter).to receive(:new)
            .with(group1)
            .and_return(group_presenter1)
          allow(GroupNotificationPresenter).to receive(:new)
            .with(group2)
            .and_return(group_presenter2)
          allow(group_presenter1).to receive(:latest_data)
            .and_return(latest_data_1)
          allow(group_presenter2).to receive(:latest_data)
            .and_return(latest_data_2)
        end

        it 'returns an array with latest_data for each group' do
          expect(helper.last_notification).to match(result)
        end
      end
    end

    let(:group1) { instance_double(Group) }
    let(:group2) { instance_double(Group) }

    it 'iterates through all groups' do
      expect(Group).to receive(:find_each)
      helper.last_notification
    end

    test_groups_with_changes('when there are groups with changes', [3, 4], 2)
    test_groups_with_changes(
      'when there are groups with changes and groups with no changes', [], 1
    )
  end

  describe '#attribute_to_html' do
    it 'displays html for string correctly' do
      expect(helper.attribute_to_html('string')).to eq('<p>string</p>')
    end

    it 'displays html for string with new line correctly' do
      expect(helper.attribute_to_html("string\nnext"))
        .to eq("<p>string\n<br />next</p>")
    end

    it 'displays html for arrays correctly' do
      ary = %w[str1 str2]
      expect(helper.attribute_to_html(ary)).to eq("<p>str1\n<br />str2</p>")
    end

    it 'displays html for numbers correctly' do
      expect(helper.attribute_to_html(1.0)).to eq(1.0)
    end
  end
end
