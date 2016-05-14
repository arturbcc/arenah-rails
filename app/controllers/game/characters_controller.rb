# frozen_string_literal: true

class Game::CharactersController < Game::BaseController
  def index
    @area = Area.new(:characters)
  end

  def sheet
  end

  def list
    render json: { list: @game.characters, pcs: @game.pcs }
  end
end
