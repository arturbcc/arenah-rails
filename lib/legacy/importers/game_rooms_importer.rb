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

          character = characters.find { |character| character.id == game.author_id}

          if !character
            games.reject! { |g| g.id == game.id }
          else
            game.create!(character.arenah_character)
          end

          bar.inc
        end

        bar.finished
        puts "#{Game.count} games created"
        puts ''
      end
    end
  end
end
