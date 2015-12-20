class Game::BaseController < ApplicationController
  before_action :load_game

  protected

  def load_game
    @game = Game.friendly.find(game_slug)
  end

  def game_slug
    params[:game]
  end
end
