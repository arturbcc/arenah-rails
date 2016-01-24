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
    @post = Post.where(topic: @topic, id: params[:id])
    @recipients = @post.present? ? @post.recipients.map(&:name) : ''
  end

  private

  def get_topic
    @topic = Topic.find_by(
      slug: params[:topic],
      game_id: current_game.id)
  end
end
