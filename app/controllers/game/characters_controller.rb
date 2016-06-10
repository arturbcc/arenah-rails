# frozen_string_literal: true

class Game::CharactersController < Game::BaseController
  def index
    @area = Area.new(:characters)
  end

  def sheet
  end

  def list
    render json: { list: @game.characters.active, pcs: @game.pcs.active }
  end
end
