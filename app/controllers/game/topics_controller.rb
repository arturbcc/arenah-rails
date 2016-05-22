# frozen_string_literal: true

class Game::TopicsController < Game::BaseController
  before_action :authenticate_user!, except: :index

  def index
    @area = Area.new(:topics)
  end

  def destroy
    status = 422

    if current_topic.present?
      if @identity.game_master?
        current_topic.destroy!

        status = 200
      end
    end

    render json: { status: status }
  end
end
