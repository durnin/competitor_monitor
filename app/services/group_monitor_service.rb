# frozen_string_literal: true

# Decorator class to record competitor data from Amazon
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
