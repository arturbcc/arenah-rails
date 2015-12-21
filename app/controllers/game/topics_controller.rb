class Game::TopicsController < Game::BaseController
  def index
    @area = Area.new(:topics)
  end
end
