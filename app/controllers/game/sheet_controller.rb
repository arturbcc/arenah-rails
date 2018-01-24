# frozen_string_literal: true

class Game::SheetController < Game::BaseController
  def show
    @game = character.game
    @sheet = SheetPresenter.new(character)

    render :show, layout: false
  end

  def update
  end

  private

  def character
    @character ||= Character.friendly.find(params[:character_slug])
  end
end
