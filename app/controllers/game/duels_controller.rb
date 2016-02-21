# frozen_string_literal: true

class Game::DuelsController < Game::BaseController
  def index
    @area = Area.new(:duels)
  end

  def show
    id = params[:id]
  end
end
