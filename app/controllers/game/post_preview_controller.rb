# frozen_string_literal: true

class Game::PostPreviewController < Game::BaseController
  before_action :authenticate_user!

  def show
    @message = Parsers::Post.parse(params[:message])
    render :show, layout: false
  end
end
