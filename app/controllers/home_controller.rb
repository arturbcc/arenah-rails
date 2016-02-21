# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @games = Game.all
    render :index, layout: false
  end
end
