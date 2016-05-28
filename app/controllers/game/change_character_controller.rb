# frozen_string_literal: true

class Game::ChangeCharacterController < Game::BaseController
  def show
    profile = current_user.characters.find { |character| character == current_character }

    if profile
      redirect_to game_topics_path(profile.game)
    else
      raise Exceptions::Unauthorized.new
    end
  end
end
