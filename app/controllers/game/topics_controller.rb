# frozen_string_literal: true

class Game::TopicsController < Game::BaseController
  before_action :authenticate_user!, except: :index
  before_action :set_area

  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
  end

  def new
    @topic = Topic.new
    @groups = []

    render partial: 'shared/modal', locals: {
      partial_name: 'new',
      save_button: true,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def create
    if @identity.game_master?
      topic = Topic.new(topic_params).tap do |topic|
        topic.game = current_game
        topic.character_id = current_character.id
        topic.position = Topic.by_group_id(params[:topic_group_id]).count + 1
      end

      topic.save!
    end

    redirect_to game_topics_path(current_game)
  end

  def edit
    @topic = current_topic

    render partial: 'shared/modal', locals: {
      partial_name: 'edit',
      save_button: true,
      save_method: 'newContent.save.bind(newContent)'
    }
  end

  def update
    if @identity.game_master?
      current_topic.update(topic_params)
    end

    redirect_to game_topics_path(current_game)
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

  private

  def set_area
    @area = Area.new(:topics)
  end

  def topic_params
    params.permit(:id, :title, :description, :topic_group_id)
  end
end
