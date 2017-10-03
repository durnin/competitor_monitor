# frozen_string_literal: true

require 'rails_helper'

describe 'rake amazon:scrape_groups', type: :task do
  before do
    allow(FetchGroupDataJob).to receive(:perform_later).with(any_args)
                                                       .and_return(true)
  end

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no groups' do
    expect { task.execute }.not_to raise_error
  end

  it 'logs to stdout' do
    expect { task.execute }.to output('Executing amazon:scrape_groups, jobs '\
    "for scraping each group will be enqueued\n").to_stdout
  end

  context 'with groups' do
    before do
      create(:group, :with_competitors)
    end

    it 'runs gracefully' do
      expect { task.execute }.not_to raise_error
    end
  end
end
