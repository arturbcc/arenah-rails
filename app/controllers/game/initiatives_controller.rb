# frozen_string_literal: true

class Game::InitiativesController < Game::BaseController
  before_action :authenticate_user!

  def show
    @ids = characters_ids

    render :show, layout: false
  end

  private

  def characters_ids
    ids =  params.fetch(:group_characters, '')
    ids.split(',').map(&:to_i)
  end
end
