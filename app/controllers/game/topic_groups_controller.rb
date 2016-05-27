# frozen_string_literal: true

class Game::TopicGroupsController < Game::BaseController
  before_action :authenticate_user!
  before_action :set_area

  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def new
    @topic_group = TopicGroup.new
    @groups = current_game.topic_groups

    render partial: 'shared/modal', locals: {
      partial_name: 'new',
      save_button: true,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def create
  end

  def edit
    @topic_group = current_topic_group
    @groups = current_game.topic_groups

    render partial: 'shared/modal', locals: {
      partial_name: 'edit',
      save_button: true,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def update
  end

  def destroy
    status = 422

    if @identity.game_master?
      group = current_game.topic_groups.find { |group| group.slug == params[:id] }
      group.destroy! if group

      status = 200
    end

    render json: { status: status }
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

  private

  def set_area
    @area = Area.new(:topics)
  end

  def topic_group_params
    params.permit(:id, :title)
  end

  def current_topic_group
    @current_topic_group ||=
      current_game.topic_groups.find { |group| group.slug == topic_group_params[:id] }
  end
end
