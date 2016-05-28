module TopicsHelper
  def link_to_last_post(game, topic)
    total_pages = topic.posts
      .paginate(page: 1, per_page: Post::PER_PAGE).total_pages

    page = total_pages if total_pages > 1
    anchor = "post#{topic.posts.last.id}" if topic.posts.any?

    game_posts_path(game,
      topic,
      page: page,
      anchor: anchor)
  end
end
