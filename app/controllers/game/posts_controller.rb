# frozen_string_literal: true

class Game::PostsController < Game::BaseController
  before_action :get_topic

  def index
    @area = Area.new(:posts)
    @posts = @topic.posts
  end

  def new
    @area = Area.new(:create_post)
    @post = Post.new
  end

  def edit
    @area = Area.new(:edit_post)
    @post = Post.find_by(topic: @topic, id: params[:id])
    @recipients = @post.present? ? @post.recipients.map(&:name) : ''
  end

  def destroy
    authenticate_user!

    status = 422

    if @topic.present?
      post_id = params[:id]
      post = Post.find_by(topic: @topic, id: post_id)
      ability = Ability.new(@identity, post, current_character)

      if ability.can_delete?
        post.destroy!

        recalculate_topic_last_post if post_id.present? && post_id == @topic.post_id
        status = 200
      end
    end

    # TODO: fazer testes para todos os casos
    render json: { status: status }
  end

  private

  def get_topic
    @topic = Topic.find_by(
      slug: params[:topic],
      game_id: current_game.id)
  end

  def recalculate_topic_last_post
    last_post = Post.where(topic: @topic).last
    @topic.post_id = last_post.id
    @topic.save!
  end
end
