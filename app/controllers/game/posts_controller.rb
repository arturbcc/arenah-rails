class Game::PostsController < Game::BaseController
  def index
    @area = Area.new(:posts)
    @character = Character.new
    @topic = Topic.friendly.find(params[:topic])
    @posts = @topic.posts
  end
end
