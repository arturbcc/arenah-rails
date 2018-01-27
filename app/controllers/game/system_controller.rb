# frozen_string_literal: true

class Game::SystemController < Game::BaseController
  def show
    render json: @game.system
  end
end
