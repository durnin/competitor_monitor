# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchGroupDataJob, type: :job do
  include ActiveJob::TestHelper

  let(:group) { create(:group, :with_competitors)}
  let(:service) { instance_double (GroupMonitorService) }
  subject(:job) { described_class.perform_later(group) }
  before do
    allow(GroupMonitorService).to receive(:new).with(group)
      .and_return(service)
    allow(service).to receive(:fetch_all)
      .and_return(true)
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
                          .with(group)
                          .on_queue('default')
  end

  it 'executes perform' do
    expect(GroupMonitorService).to receive(:new).with(group)
    perform_enqueued_jobs { job }
  end

  context 'when an error raises' do
    before do
      allow(service).to receive(:fetch_all).and_raise(StandardError)
    end

    it 'handles standard error' do
      perform_enqueued_jobs do
        expect_any_instance_of(FetchGroupDataJob)
          .to receive(:retry_job).with(wait: 10.minutes, queue: :default)
        job
      end
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
