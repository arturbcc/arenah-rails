# frozen_string_literal: true

class Game::SheetController < Game::BaseController
  def show
    @character = Character.friendly.find(params[:character_slug])
    @game = @character.game
    @sheet = SheetPresenter.new(@character)

    render :show, layout: false
  end

  def update
    # TODO: check if the user is master or character owner before saving.
    # TODO: log modifications to show to the game master

    character = Character.friendly.find(params[:character_slug])
    status = character&.update_sheet(params[:group_name], params[:character_attributes])

    if status
      head :ok
    else
      head :not_found
    end
  end
end
