# frozen_string_literal: true

require 'legacy/legacy_post'
module Legacy
  module Importers
    class PostsImporter
      def self.import(posts, topics, characters, games, user_partners)
        puts '8. Creating posts...'
        bar = RakeProgressbar.new(posts.count)

        errors = []
        posts.each do |post|
          bar.inc

          next unless post.active?

          topic = topics.find { |topic| topic.id == post.topic_id }
          game = games.find { |game| game.id == topic.forum_id }
          game = games.find { |g| g.id == game.parent_forum_id } unless game.root?

          character = characters.find { |c| c.user_partner_id == post.author_id && c.forum_id == game.id }

          next unless topic && topic.arenah_topic

          if !character || !character.arenah_character
            errors << post
          else
            post.create!(topic.arenah_topic, character.arenah_character)
          end
        end

        bar.finished
        puts "#{Post.count} posts created"

        puts "#{errors.map(&:author_id).uniq.count} authors ignored because of database inconsistencies"

        puts ''
      end
    end
  end
end
