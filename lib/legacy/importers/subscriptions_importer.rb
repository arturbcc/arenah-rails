# frozen_string_literal: true

module Legacy
  module Importers
    class SubscriptionsImporter
      def self.import(characters, games, user_partners, moderators)
        subscribe_characters(characters, games, user_partners)
        subscribe_masters(characters, games, user_partners, moderators)
      end

      def self.subscribe_characters(characters, games, user_partners)
        puts '9. Subscribing characters...'
        bar = RakeProgressbar.new(characters.count)

        characters.each do |character|
          bar.inc
          next if character.master? || character.arenah_character.game_id.present?

          game = games.find { |game| game.id == character.forum_id }

          if game.nil?
            puts "Didn't find a game for #{character.name}"
          else
            character.arenah_character.update(game: game.arenah_game)
          end
        end

        bar.finished
        puts ''
      end

      def self.subscribe_masters(characters, games, user_partners, moderators)
        puts '10. Subscribing game masters...'
        bar = RakeProgressbar.new(characters.count)

        moderators.each do |moderator|
          game = games.find { |game| game.id == moderator.forum_id }
          next unless game.root?


          user_partner = user_partners.find { |up| up.id == moderator.user_id }
          character = characters.find do |char|
            char.user_partner_id == user_partner.id &&
            char.master? &&
            char.forum_id == moderator.forum_id
          end
          character.arenah_character.update(game: game.arenah_game)
          bar.inc
        end

        bar.finished
        puts ''
      end
    end
  end
end
