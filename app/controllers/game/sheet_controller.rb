# frozen_string_literal: true

class Game::SheetController < Game::BaseController
  def show
    @character = Character.friendly.find(params[:character_slug])
    @game = @character.game
    @sheet = SheetPresenter.new(@character)

    render :show, layout: false
  end

  def update
  end
end
