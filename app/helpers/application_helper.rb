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

  def alert_messages(flash, model_object = nil)
    model_errors = model_error_messages_list(model_object)
    flash.map do |key, text|
      alert_class = case key
                    when 'notice'
                      'alert alert-success'
                    when 'error'
                      'alert alert-danger'
                    else
                      'alert alert-info'
                    end
      messages_html(alert_class, text, model_errors)
    end.join.html_safe
  end

  def model_error_messages_list(model_object)
    if model_object
      content_tag(
        :ul,
        model_object.errors.full_messages.map { |msg| content_tag(:li, msg) }
          .join.html_safe
      )
    else
      ''
    end
  end

  private

  def messages_html(alert_class, general_msg, other_msgs)
    content = content_tag(:strong, general_msg) + other_msgs
    content_tag(:div, content,
                class: alert_class,
                role: 'alert')
  end
end
