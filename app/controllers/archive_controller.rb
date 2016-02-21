# frozen_string_literal: true

class ArchiveController < Game::BaseController
  def index
    @area = Area.new(:archive)
    @games = Archive.all
  end
end
