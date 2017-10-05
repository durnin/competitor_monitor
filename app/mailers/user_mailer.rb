# frozen_string_literal: true

# Mailer for users
class UserMailer < ApplicationMailer
  include UserNotificationHelper
  helper UserNotificationHelper

  # TODO: User as parameter in case of many-user system
  def groups_notification_email
    @data = last_notification
    # Only send if there's something to send
    return unless @data.any?
    rails_secrets = Rails.application.secrets
    send_to = rails_secrets.user_default_email
    send_from = 'notifications@' + rails_secrets.domain_name
    mail(from: send_from, to: send_to,
         subject: 'Competitor-Monitor Changes Notification')
  end
end
