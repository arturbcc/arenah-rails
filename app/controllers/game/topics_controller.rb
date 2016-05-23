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

  def sort
    status = 403

    if @identity.game_master?
      JSON.parse(params['changes']).each do |topic_id, position|
        current_game.topics.find { |topic| topic.id == topic_id.to_i }
          .update(position: position)
      end

      status = 200
    end

    render json: { status: status }
  end
end
