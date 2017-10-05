# frozen_string_literal: true

# Helper module to create data to show a user the changes in his groups
# TODO: In case of a many-user system, add user parameter
module UserNotificationHelper
  def last_notification
    res = []
    Group.find_each do |group|
      group_data = GroupNotificationPresenter.new(group).latest_data
      # If there are no changes don't include
      res << group_data if group_data[:competitors].any?
    end
    res
  end

  def attribute_to_html(att)
    if att.is_a?(String)
      simple_format(att)
    elsif att.is_a?(Array)
      simple_format(att.join("\n"))
    else
      att
    end
  end
end
