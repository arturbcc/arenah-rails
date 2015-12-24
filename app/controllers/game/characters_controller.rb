class Game::CharactersController < Game::BaseController
  def index
    @area = Area.new(:characters)
  end

  def sheet
  end
end
