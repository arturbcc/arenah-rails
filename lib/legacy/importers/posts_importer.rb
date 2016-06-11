# frozen_string_literal: true

require 'legacy/legacy_post'
module Legacy
  module Importers
    class PostsImporter
      def self.import(posts, topics, characters, games, user_partners, users)
        puts '8. Creating posts...'
        bar = RakeProgressbar.new(posts.count)

        posts.sort_by { |post| post.created_at }.each do |post|
          bar.inc

          next unless post.active?

          topic = topics.find { |topic| topic.id == post.topic_id }

          game = nil

          if post.user_account_id
            character = characters.find { |c| c.id == post.user_account_id }
          else
            game = games.find { |game| game.id == topic.forum_id }
            game = games.find { |g| g.id == game.parent_forum_id } unless game.root?
            candidates = characters.select { |c| c.user_partner_id == post.author_id && c.forum_id == game.id }

            if candidates.count == 1
              character = candidates.first
            else
              character = candidates.find { |c| c.master? }
            end
          end

          next unless topic && topic.arenah_topic

          if !character || !character.arenah_character
            character = create_character(post, game, user_partners, users, characters)
          end

          post.create!(topic.arenah_topic, character.arenah_character)
        end

        bar.finished
        puts "#{Post.count} posts created"

        puts ''
      end

      def self.create_character(post, game, user_partners, users, characters)
        user_partner = user_partners.find { |up| up.id == post.author_id }
        user = users.find { |user| user.id == user_partner.user_id }
        character = user_partner.build_legacy_character(game.id)
        character.status = 1
        character.character_type = 0
        character.create!(user.arenah_user)
        character.arenah_character.update(game_id: game.arenah_game.id)
        characters << character

        character
      end
    end
  end
end
