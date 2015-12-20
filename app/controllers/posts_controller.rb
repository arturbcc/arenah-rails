class PostsController < ApplicationController
  def index
    @area = Area.new
    @character = Character.new
    @game = Game.friendly.find(params[:game])
    @topic = Topic.friendly.find(params[:topic])
    @posts = @topic.posts
  end
end
