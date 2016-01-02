class AboutController < Game::BaseController
  def show
    @area = Area.new(:about)
  end
end
