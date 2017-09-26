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
end
