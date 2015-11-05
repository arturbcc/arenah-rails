class PostsController < ApplicationController
  def index
    @identity = Identity.new(:unlogged)
    @area = Area.new
    @character = Character.new
    @game = Game.friendly.find(params[:game])
    @topic = Topic.friendly.find(params[:topic])
    @posts = @topic.posts #Post.where(game: params[:game], topic: params[:topic])
  end

  private

  # def posts_params
  #   params.require(:game).require(:topic)
  # end
end
