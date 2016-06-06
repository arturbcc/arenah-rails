# frozen_string_literal: true

require 'legacy/legacy_post'
module Legacy
  module Importers
    class PostsImporter
      def self.import(posts, topics, characters, games, user_partners, users)
        puts '8. Creating posts...'
        bar = RakeProgressbar.new(posts.count)

        posts.each do |post|
          bar.inc

          next unless post.active?

          topic = topics.find { |topic| topic.id == post.topic_id }

          if post.user_account_id
            character = characters.find { |c| c.id == post.user_account_id }
          else
            game = games.find { |game| game.id == topic.forum_id }
            game = games.find { |g| g.id == game.parent_forum_id } unless game.root?
            character = characters.find { |c| c.user_partner_id == post.author_id && c.forum_id == game.id && c.master? }
          end

          next unless topic && topic.arenah_topic

          if !character || !character.arenah_character
            character = create_character(post, game.id, user_partners, users)
          end

          post.create!(topic.arenah_topic, character.arenah_character)
        end

        bar.finished
        puts "#{Post.count} posts created"

        puts ''
      end

      def self.create_character(post, forum_id, user_partners, users)
        user_partner = user_partners.find { |up| up.id == post.author_id }
        user = users.find { |user| user.id == user_partner.user_id }
        character = user_partner.build_legacy_character(forum_id)
        character.create!(user.arenah_user)

        character
      end
    end
  end
end
