# frozen_string_literal: true

require 'legacy/legacy_game'
module Legacy
  module Importers
    class GameRoomsImporter
      def self.import(games, user_partners, characters)
        puts '5. Creating game rooms...'
        bar = RakeProgressbar.new(games.count)
        root_games = games.select { |game| game.root? }

        root_games.each do |game|
          next unless game.game_room?

          user_partner = user_partners.find { |user| user.id == game.author_id }
          character = characters.find { |character| character.user_partner_id == user_partner.id }
          game.create!(character.arenah_character)

          user_partner.game_id = game.id

          bar.inc
        end

        bar.finished
        puts "#{Game.count} games created"
        puts ''
      end
    end
  end
end
