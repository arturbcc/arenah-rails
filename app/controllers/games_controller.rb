class GamesController < ApplicationController
  def show
    @area = Area.new(:home)
    @game = Game.friendly.find(game_slug)
  end

  private

  def game_slug
    params[:game]
  end
end
