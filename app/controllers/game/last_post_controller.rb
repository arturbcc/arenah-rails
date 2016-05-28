# frozen_string_literal: true

# Public: redirects to the last post of the topic. It is a middleware between
# the topic the posts pages, created to improve the general performance of the
# topics page.
#
# Because it is necessary to point the user to the last post of the topic, every
# topic needs to perform checks on the database to calculate the number of pages
# and to find the last post id, which is expensive since all topics are loaded
# in the page even though only a small portion of them are shown at a time.
#
# With this redirect approach, only when a user clicks on a topic those database
# queries are executed, and just for one topic. This leverage the load and improve
# the speed of the page
class Game::LastPostController < Game::BaseController
  def show
    total_pages = current_topic.posts
      .paginate(page: 1, per_page: Post::PER_PAGE).total_pages

    page = total_pages if total_pages > 1
    anchor = "post#{current_topic.posts.last.id}" if current_topic.posts.any?

    redirect_to game_posts_path(
      current_game,
      current_topic,
      page: page,
      anchor: anchor)
  end
end
