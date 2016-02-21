# frozen_string_literal: true

class Game::HomeController < Game::BaseController
  def show
    @area = Area.new(:home)
  end
end
