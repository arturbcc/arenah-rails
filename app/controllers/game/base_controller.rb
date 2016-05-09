# frozen_string_literal: true

class Game::BaseController < ApplicationController
  before_action :load_game, :load_character, :set_identity
  rescue_from Exceptions::Unauthorized, with: :unauthorized_access

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
        if master?
          role = :game_master
        else
          role = player? ? :player : :visitor
        end
      else
        role = :visitor
      end
    end

    @identity = Identity.new(role)
  end

  def master?
    current_user.characters.where(
      game_id: current_game.id,
      character_type: 2).present?
  end

  def player?
    player = current_user.characters.where(
      game_id: current_game.id,
      character_type: 0).present?
  end

  def unauthorized_access
    render 'shared/unauthorized', status: :unauthorized, layout: false
  end
end
