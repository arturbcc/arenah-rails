class PostsController < ApplicationController
  def index
    @identity = Identity.new(:unlogged)
    @area = Area.new
    @character = Character.new
    @game = Game.friendly.find(params[:game])
    @topic = Topic.friendly.find(params[:topic])
    @posts = @topic.posts
  end
end