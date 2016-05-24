# frozen_string_literal: true

class Game::TopicGroupsController < Game::BaseController
  before_action :authenticate_user!

  def edit
  end

  def destroy
  end

  def sort
    status = 403

    if @identity.game_master?
      JSON.parse(params['changes']).each do |group_id, position|
        current_game.topic_groups.find { |group| group.id == group_id.to_i }
          .update(position: position)
      end

      status = 200
    end

    render json: { status: status }
  end
end
