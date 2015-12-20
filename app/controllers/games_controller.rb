class GamesController < ApplicationController
  before_action :load_game

  def show
    @area = Area.new(:home)
  end

  def subscription
    @area = Area.new(:inscription)

    #TODO: load subscribed only if user is logged?
    @subscribed = Subscription.where(user: @user, game: @game).present?
  end

  private

  def load_game
    @game = Game.friendly.find(game_slug)
  end

  def game_slug
    params[:game]
  end
end
