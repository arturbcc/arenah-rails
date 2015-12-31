class Game::BaseController < ApplicationController
  before_action :load_game, :set_identity

  attr_reader :identity

  def current_game
    @game
  end

  protected

  def load_game
    @game = Game.friendly.find(params[:game]) if params[:game].present?
  end

  def set_identity
    role = :unlogged

    if user_signed_in?
      if current_game.present?
        masters = current_user.characters.where(game_id: current_game.id, character_type: 2)
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
