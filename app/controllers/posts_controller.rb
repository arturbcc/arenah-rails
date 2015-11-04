class PostsController < ApplicationController
  def index
    @posts = Post.where(game: params[:game], topic: params[:topic])
  end

  private

  # def posts_params
  #   params.require(:game).require(:topic)
  # end
end
