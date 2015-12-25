module UserHelper
  def user_avatar(user, options = {})
    options = options.merge(alt: user.name, title: user.name)
    content_tag :div, user.name.first, class: 'user-avatar'
  end
end
