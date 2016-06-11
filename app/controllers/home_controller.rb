# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @games = Game.active.sort_by { |game| game.name }
    render :index, layout: false
  end
end
