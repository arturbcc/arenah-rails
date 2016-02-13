class Game::SheetController < Game::BaseController
  def show
    character = Character.friendly.find(params[:character_slug])
    @sheet = SheetPresenter.new(character)

    render :show, layout: false
  end
end
