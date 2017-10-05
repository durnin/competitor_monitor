# frozen_string_literal: true

# View object class to represent changes in a monitored
# group to notify user
class GroupNotificationPresenter
  def initialize(group)
    @group = group
  end

  # Latest data to notify to user
  def latest_data
    res = { name: @group.name, competitors: [] }.with_indifferent_access
    @group.competitors.each do |competitor|
      add_competitor_changes(competitor, res)
    end
    res
  end

  private

  def add_competitor_changes(competitor, res)
    c_changes = competitor.versions.last.changeset
    return unless c_changes.length > 1 # has something else besides updated_at
    c_hash = { name: competitor.name }.with_indifferent_access
    c_hash[:changes] = c_changes.delete_if { |key, _| key == 'updated_at' }
                                .with_indifferent_access
    res[:competitors] << c_hash
  end
end
