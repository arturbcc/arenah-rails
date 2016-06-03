# frozen_string_literal: true

module Legacy
  module Importers
    class SubscriptionsImporter
      def self.import(characters, games, user_partners)
        puts '9. Subscribe characters...'

        characters.each do |character|
          next unless character.active?

          if character.post_count == 0
            puts "Skipping #{character.name}"
            next
          end

          game = games.find { |game| game.id == character.forum_id }
          unless game
            user_partner = user_partners.find { |up| up.id == character.user_partner_id }
            game = games.find { |game| game.id == user_partner.game_id }
          end

          character.arenah_character.update(game: game.arenah_game)
        end

        puts ''
      end
    end
  end
end
