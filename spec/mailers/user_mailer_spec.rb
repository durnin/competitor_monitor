# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#groups_notification_email' do
    it 'does not send mail if no changes to send' do
      expect { UserMailer.groups_notification_email.deliver_now }
        .to_not(change { ActionMailer::Base.deliveries.count })
    end

    context 'when there is changes to send to the user' do
      let(:last_notification_result) do
        [{ name: 'Group1', competitors: [] }.with_indifferent_access,
         { name: 'Group2', competitors: [] }.with_indifferent_access]
      end
      let(:mail) { UserMailer.groups_notification_email }
      let(:user_to) { Rails.application.secrets.user_default_email }
      let(:user_from) do
        'notifications@' + Rails.application.secrets.domain_name
      end

      before do
        allow_any_instance_of(UserMailer).to receive(:last_notification)
          .and_return(last_notification_result)
      end

      it 'sends an email' do
        expect { mail.deliver_now }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq('Competitor-Monitor Changes Notification')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user_to])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq([user_from])
      end

      it 'renders the body' do
        expect(mail.body.encoded).to include(
          'Some changes were detected in your groups'
        )
      end
    end
  end
end
