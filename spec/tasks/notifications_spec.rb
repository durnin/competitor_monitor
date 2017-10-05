# frozen_string_literal: true

require 'rails_helper'

describe 'rake notifications:user_latest_changes', type: :task do
  before do
    allow(UserMailer).to receive_message_chain(
      :groups_notification_email,
      :deliver_later
    ).with(any_args).and_return(true)
  end

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no groups' do
    expect { task.execute }.not_to raise_error
  end

  it 'logs to stdout' do
    expect { task.execute }.to output('Executing notifications:user_'\
      "latest_changes, mails will be enqueued with changes\n").to_stdout
  end

  it 'calls user mailer' do
    expect(UserMailer).to receive_message_chain(
      :groups_notification_email,
      :deliver_later
    )
    task.execute
  end
end
