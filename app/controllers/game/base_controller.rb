class Game::BaseController < ApplicationController
  before_action :load_game, :set_identity

  protected

  def load_game
    @game = Game.friendly.find(game_slug) if game_slug.present?
  end

  def game_slug
    params[:game]
  end

  def set_identity
    role = :unlogged

    if user_signed_in?
      if @game
        masters = current_user.characters.where(game_id: @game.id, character_type: 2)
        if masters.present?
          role = :game_master
        else
          role = :player
        end
      else
        role = :visitor
      end
    end

    @identity = Identity.new(role)
  end
end
