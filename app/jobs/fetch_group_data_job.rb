# frozen_string_literal: true

# Job to fetch all competitors data from a group
class FetchGroupDataJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |error|
    Rails.logger.error(error.message)
    retry_job wait: 10.minutes, queue: :default
  end

  def perform(group)
    GroupMonitorService.new(group).fetch_all
  end
end
