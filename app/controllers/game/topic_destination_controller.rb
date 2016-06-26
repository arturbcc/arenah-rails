# frozen_string_literal: true

# Public: redirects to the posts page of the topic, respecting the topic/group
# rule of redirecting to the first or last page. It is a middleware between
# the topic and the posts pages, created to improve the general performance of
# the topics page.
#
# Because it is necessary to point the user to the first or last post of the topic, every
# topic needs to perform checks on the database to calculate the number of pages
# and to find the expected post id, which is expensive since all topics are loaded
# in the page even though only a small portion of them are shown at a time.
#
# With this redirect approach, only when a user clicks on a topic those database
# queries are executed, and just for one topic. This leverages the load and improve
# the speed of the page
class Game::TopicDestinationController < Game::BaseController
  def show
    if current_topic.redirect_to_last_page?
      total_pages = current_topic.posts
        .paginate(page: 1, per_page: Post::PER_PAGE).total_pages

      page = total_pages if total_pages > 1
      anchor = "post#{current_topic.posts.last.id}" if current_topic.posts.any?
    else
      page = 1
      anchor = "post#{current_topic.posts.first.id}" if current_topic.posts.any?
    end

    redirect_to game_posts_path(
      current_game,
      current_topic,
      page: page,
      anchor: anchor)
  end
end
