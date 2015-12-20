module GameHelper
  include ApplicationHelper

  def menu_item(area, options = {})
    url = options[:url] || 'javascript:;'
    klass = 'active' if area.current == options[:area]

    link = link_to url, class: klass do
      concat(icon options[:icon]) if options[:icon]
      concat(content_tag :strong, options[:title]) if options[:title]
      concat(content_tag :small, options[:subtitle]) if options[:subtitle]
    end

    content_tag :li, link
  end

  def banner(game)
    if game.banner.present?
      image_tag banner_path(game), alt: game.name
    else
      image_tag default_banner_path, alt: game.name
    end
  end

  def custom_css(game)
    "<link href='/games/#{game.slug}/css/custom.css' rel='stylesheet'>".html_safe if game.present?
  end

  private

  def banner_path(game)
    "/games/#{game.slug}/images/banners/#{game.banner}"
  end

  def default_banner_path
    '/images/defaults/banner.jpg'
  end
end
