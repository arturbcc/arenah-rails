class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @games = Game.all
    render :index, layout: false
  end
end
