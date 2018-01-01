# frozen_string_literal: true

class Game::GamesController < Game::BaseController
  def index
  end
  
  def show
    render json: @game
  end
end
