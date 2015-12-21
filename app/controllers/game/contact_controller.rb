class Game::ContactController < Game::BaseController
  def show
    @area = Area.new(:contact)
  end
end
