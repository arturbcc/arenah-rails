# frozen_string_literal: true

class Game::TopicsController < Game::BaseController
  def index
    @area = Area.new(:topics)
  end
end
