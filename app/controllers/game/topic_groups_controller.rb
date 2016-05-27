# frozen_string_literal: true

class Game::TopicGroupsController < Game::BaseController
  before_action :authenticate_user!
  before_action :set_area

  def new
    @topic_group = TopicGroup.new
    @limit_reached = limit_reached?

    render partial: 'shared/modal', locals: {
      partial_name: 'new',
      save_button: !limit_reached?,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def create
    if @identity.game_master? && !limit_reached?
      group = TopicGroup.new(topic_group_params).tap do |group|
        group.game = current_game
        group.position = TopicGroup.count+ 1
      end

      group.save!
    end

    redirect_to game_topics_path(current_game)
  end

  def edit
    @topic_group = current_topic_group

    render partial: 'shared/modal', locals: {
      partial_name: 'edit',
      save_button: true,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def update
    if @identity.game_master?
      current_topic_group.update(topic_group_params)
    end

    redirect_to game_topics_path(current_game)
  end

  def destroy
    status = 422

    if @identity.game_master?
      current_topic_group.destroy!

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
    params.permit(:name)
  end

  def current_topic_group
    @current_topic_group ||=
      current_game.topic_groups.find { |group| group.slug == params[:topic_group] }
  end

  def limit_reached?
    current_game.topic_groups.length >= TopicGroup::TOPIC_GROUP_LIMIT
  end
end
