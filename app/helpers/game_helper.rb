module GameHelper
  def banner(game)
    if game.banner.present?
      image_tag banner_path(game), alt: game.name
    else
      image_tag default_banner_path
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
