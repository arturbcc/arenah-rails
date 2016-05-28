# frozen_string_literal: true

module UserHelper
  def user_avatar(user, options = {})
    options = { alt: user.name, title: user.name }.merge(options)
    content_tag :div, user.name.first, class: 'user-avatar'
  end
end
