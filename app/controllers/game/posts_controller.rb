# frozen_string_literal: true

class Game::PostsController < Game::BaseController
  before_action :get_topic
  before_action :authenticate_user!, except: :index

  def index
    @area = Area.new(:posts)
    @posts = current_topic.posts
  end

  def new
    @area = Area.new(:create_post)
    @post = Post.new
  end

  def edit
    @area = Area.new(:edit_post)
    @post = current_post
    @recipients = @post.present? ? @post.recipients.map(&:name) : ''
  end

  def create
    if current_user_ability.can_write_post?
      if create_post
        # @topic.recalculate_last_post
        redirect_to game_posts_path(current_game, current_topic)
      else
        redirect_to game_new_post_path(current_game, current_topic),
          flash: 'Não foi possível enviar a mensagem'
      end
    else
      raise Exceptions::Unauthorized.new
    end
  end

  def update
    if current_user_ability.can_edit?
      if update_post
        redirect_to game_posts_path(current_game, current_topic)
      else
        redirect_to game_edit_post_path(current_game, current_topic, current_post),
          flash: 'Não foi possível editar a mensagem'
      end
    else
      raise Exceptions::Unauthorized.new
    end
  end

  def destroy
    status = 422

    if current_topic.present?
      if current_user_ability.can_delete?
        current_post.destroy!

        # @topic.recalculate_last_post
        status = 200
      end
    end

    # TODO: make tests to all cases
    render json: { status: status }
  end

  private

  def get_topic
    @topic = current_topic
  end

  def current_topic
    @current_topic ||= Topic.find_by(
      slug: params[:topic],
      game_id: current_game.id)
  end

  def current_post
    @current_post ||= Post.find_by(topic: @topic, id: params[:id])
  end

  def current_user_ability
    @ability ||= Ability.new(@identity, current_post, current_character)
  end

  def post_params
    params.require(:post).permit(:message, :recipients)
  end

  def recipients(recipients)
    return [] if recipients.blank?

    recipients.split(',').map do |character_id|
      Character.find(character_id.to_i)
    end
  end

  def create_post
    Post.create(topic: current_topic,
      message: post_params[:message],
      character: current_character,
      recipients: recipients(post_params[:recipients])
    )
  end

  def update_post
    current_post.update(
      message: post_params[:message],
      recipients: recipients(post_params[:recipients])
    )
  end
end
