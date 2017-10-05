# frozen_string_literal: true

# Service class to fetch all group data from Amazon
class GroupMonitorService
  def initialize(group)
    @group = group
  end

  def fetch_all
    fetch_correct = true
    @group.competitors.each do |competitor|
      unless CompetitorMonitorDecorator.new(competitor).save
        Rails.logger.error(competitor.errors.messages.inspect)
        fetch_correct = false
      end
    end
    fetch_correct
  end
end
