# frozen_string_literal: true

class Game::PostsController < Game::BaseController
  attr_accessor :current_page

  skip_before_action :verify_authenticity_token, only: :destroy

  before_action :get_topic, :get_current_page
  before_action :load_recipients, only: [:new, :edit]
  before_action :authenticate_user!, except: :index

  def index
    @area = Area.new(:posts)
    @posts = paginated_posts
  end

  def new
    @area = Area.new(:create_post)
    @post = Post.new(recipients: current_post.present? ? current_post.recipients : [])
  end

  def edit
    @area = Area.new(:edit_post)
    @post = current_post
    @character = @post.character
  end

  def create
    if current_user_ability.can_write_post?
      if post = create_post
        # @topic.recalculate_last_post
        pages = paginated_posts.total_pages
        redirect_to game_posts_path(current_game,
          current_topic,
          page: pages,
          anchor: anchor_to_post(post))
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
      if post = update_post
        redirect_to game_posts_path(current_game,
          current_topic,
          page: current_page,
          anchor: anchor_to_post(current_post))
      else
        redirect_to game_edit_post_path(current_game, current_topic, current_post),
          flash: 'Não foi possível editar a mensagem'
      end
    else
      raise Exceptions::Unauthorized.new
    end
  end

  def destroy
    status = :unprocessable_entity

    if current_post && current_user_ability.can_delete?
      current_post.destroy!

      # @topic.recalculate_last_post
      status = :ok
    end

    # We can't use `:success` in the status because JQuery will assume something
    # is wrong since there is a single space in the body (it is the behavior of
    # the `head` in Rails). Instead, we need to send status :ok. It is also
    # important to send the AJAX request with `dataType : 'html'`, to bypass the
    # extra space problem.
    #
    # Check more about this here:
    # https://stackoverflow.com/questions/4791499/jquery-doesnt-call-success-method-on-ajax-for-rails-standard-rest-delete-answ
    head status
  end

  private

  def get_topic
    @topic = current_topic
  end

  def current_post
    @current_post ||= Post.find_by(topic: current_topic, id: params[:id])
  end

  def current_user_ability
    @ability ||= Ability.new(identity, current_post, current_character)
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

  def load_recipients
    @recipients = current_post.present? ? current_post.recipients.map(&:id).join(', ') : ''
  end

  def create_post
    Post.create(topic: current_topic,
      message: post_params[:message],
      character: author,
      recipients: recipients(post_params[:recipients])
    )
  end

  def update_post
    current_post.update(
      message: post_params[:message],
      recipients: recipients(post_params[:recipients])
    )
  end

  # TODO: Test trying to use an id that does not belong to the room, an id that
  # belongs to another user and current user is not master, an empty id, without
  # any id, the id of a user that does not exist

  # Private: finds the author based on the character_id parameter. It considers
  # the params instead of always using the current_character because there is
  # a resource that allows the game masters to impersonate any of the game's
  # NPC's
  def author
    character_id = params[:post][:character_id].to_i
    return current_character unless character_id > 0 && identity.game_master?

    npc = Character.find_by(
      id: character_id,
      game_id: current_game.id,
      character_type: 1)

    npc || current_character
  end

  def paginated_posts
    current_topic.posts.paginate(page: current_page, per_page: Post::PER_PAGE)
  end

  def get_current_page
    @current_page = params[:page] || 1
  end

  def anchor_to_post(post)
    "post#{post.id}"
  end
end
