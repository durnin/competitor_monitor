# frozen_string_literal: true

namespace :notifications do
  desc 'Scrapes from amazon competitors data for system groups'
  task user_latest_changes: :environment do
    puts 'Executing notifications:user_latest_changes, mails will be enqueued'\
    ' with changes'
    UserMailer.groups_notification_email.deliver_later
  end
end
