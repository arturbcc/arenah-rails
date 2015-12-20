class PassportController < ApplicationController

  def logout
    #return_url
  end

  private

  def return_url
    if @game.present? && @topic.present?
      game_posts_path(@game, @topic)
    elsif game.present?
      game_home_path(@game)
    else
      params[:url]
    end
  end
end
