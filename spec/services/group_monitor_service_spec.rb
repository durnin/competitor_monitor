# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupMonitorService do
  let(:group_with_competitors) { create(:group, :with_competitors) }
  subject { GroupMonitorService.new(group_with_competitors) }
  before do
    allow_any_instance_of(CompetitorMonitorDecorator).to receive(:save)
      .and_return(true)
  end

  it 'extracts data from amazon for all competitors' do
    expect(subject.fetch_all).to be_truthy
  end
end
