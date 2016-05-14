# frozen_string_literal: true

class Game::GameController < Game::BaseController
  def show
    render json: @game
  end
end
