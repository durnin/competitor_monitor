# frozen_string_literal: true

# Rails ApplicationHelper Module
module ApplicationHelper
  def nav_menu_items
    [{ text: 'Home', link: root_path },
     { text: 'Groups', link: groups_path }].map do |menu_item|

      menu_item_link = menu_item[:link]
      menu_item_classes = if current_page?(menu_item_link)
                            'nav-item nav-link active'
                          else
                            'nav-item nav-link'
                          end
      link_to menu_item[:text], menu_item_link, class: menu_item_classes
    end.join.html_safe
  end
end
