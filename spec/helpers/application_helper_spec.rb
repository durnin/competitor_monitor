# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#nav_menu_items' do
    it 'displays html for menu items with links' do
      expect(helper.nav_menu_items).to match(
        %r{<a class="nav-item nav-link.*" href="/">Home</a>}
      )
      expect(helper.nav_menu_items).to match(
        %r{<a class="nav-item nav-link.*" href="/groups">Groups</a>}
      )
    end
  end

  context 'when trying to print alert messages' do

    let(:model_instance) { double('some_model') }

    before do
      allow(model_instance).to receive_message_chain(:errors, :full_messages)
        .and_return(['error 1', 'error 2', 'error 3'])
    end

    describe '#model_error_messages_list' do
      it 'generates html for error messages as a list' do
        expect(helper.model_error_messages_list(model_instance)).to eq(
          '<ul><li>error 1</li><li>error 2</li><li>error 3</li></ul>'.html_safe
        )
      end

      it 'generates empty html for nil model object' do
        expect(helper.model_error_messages_list(nil)).to eq('')
      end
    end

    describe '#alert_messages' do
      def test_alert_messages(flash_object, html_text)
        expect(helper.alert_messages(flash_object, model_instance)).to eq(
          html_text.html_safe
        )
      end

      it 'generates empty html for when no flash object was set' do
        flash_object = {}
        expect(helper.alert_messages(flash_object)).to eq('')
      end

      it 'generates html for success alert' do
        test_alert_messages(
          { 'notice': 'This is a notice.' }.with_indifferent_access,
          '<div class="alert alert-success" role="alert"><strong>This is a '\
          'notice.</strong><ul><li>error 1</li><li>error 2</li><li>error 3'\
          '</li></ul></div>'
        )
      end

      it 'generates html for danger alert' do
        test_alert_messages(
          { 'error': 'This is an error.' }.with_indifferent_access,
          '<div class="alert alert-danger" role="alert"><strong>This is an '\
          'error.</strong><ul><li>error 1</li><li>error 2</li><li>error 3'\
          '</li></ul></div>'
        )
      end
    end
  end
end
