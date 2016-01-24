class Game::BaseController < ApplicationController
  before_action :load_game, :load_character, :set_identity

  attr_reader :identity

  def current_game
    @game
  end

  def current_character
    @character
  end

  protected

  def load_game
    @game = Game.friendly.find(params[:game]) if params[:game].present?
  end

  def load_character
    if user_signed_in?
      @character = current_user.characters
        .where(game: current_game)
        .order(character_type: :desc).first
    end
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
