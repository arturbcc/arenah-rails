module GameHelper
  include ApplicationHelper

  def menu_item(area, options = {})
    url = options[:url] || 'javascript:;'
    klass = 'active' if area.current == options[:area]

    link = link_to url, class: klass, data: { menu: options[:area] } do
      concat(icon options[:icon]) if options[:icon]
      concat(content_tag :strong, options[:title]) if options[:title]
      concat(content_tag :small, options[:subtitle]) if options[:subtitle]
    end

    content_tag :li, link
  end

  def banner(game)
    image_tag banner_url(game), alt: game.name
  end

  def banner_url(game)
    if game.banner.present?
      banner_path(game)
    else
      default_banner_path
    end
  end

  def custom_css(game)
    "<link href='/games/#{game.slug}/css/custom.css' rel='stylesheet'>".html_safe if game.present?
  end

  def roman_number(number)
    raise 'Insert value between 1 and 3999' if number < 0 || number > 3999

    if number < 1
      ''
    elsif number >= 1000
      "M#{roman_number(number - 1000)}"
    elsif number >= 900
      "CM#{roman_number(number - 900)}"
    elsif number >= 500
      "D#{roman_number(number - 500)}"
    elsif number >= 400
      "CD#{roman_number(number - 400)}"
    elsif number >= 100
      "C#{roman_number(number - 100)}"
    elsif number >= 90
      "XC#{roman_number(number - 90)}"
    elsif number >= 50
      "L#{roman_number(number - 50)}"
    elsif number >= 40
      "XL#{roman_number(number - 40)}"
    elsif number >= 10
      "X#{roman_number(number - 10)}"
    elsif number >= 9
      "IX#{roman_number(number - 9)}"
    elsif number >= 5
      "V#{roman_number(number - 5)}"
    elsif number >= 4
      "IV#{roman_number(number - 4)}"
    elsif number >= 1
      "I#{roman_number(number - 1)}"
    else
      raise 'something bad happened'
    end
  end

  private

  def banner_path(game)
    "/games/#{game.slug}/images/banners/#{game.banner}"
  end

  def default_banner_path
    '/images/defaults/banner.jpg'
  end
end
