# frozen_string_literal: true

require 'legacy/importers/system_builder'
module Legacy
  module Importers
    class GamesSystemsImporter
      DATA = 0
      ATTRIBUTES = 1
      BACKGROUND = 2
      STATUS = 3

      def initialize(games, characters, sheets, sheet_attributes, sheet_data)
        @games = games
        @characters = characters
        @sheets = sheets
        @sheet_attributes = sheet_attributes
        @sheet_data = sheet_data
      end

      def import
        puts '12. Configuring RPG system'

        games.each do |game|
          system_id = game.game_system_id.to_i

          game_system = attributes_for(game) do
            system_id == 2 ?
              arenah_attributes(game.forum_id) :
              daemon_attributes
          end

          if game.arenah_game
            game.arenah_game.update(system: game_system.to_json)
            game.system = game_system
          else
            puts "Cannot update game #{game.name}".red
          end
        end

        puts ''
        replicate_sheet_to_characters
      end

      private

      def games
        @games.select { |game| game.root? }.sort_by { |game| game.name }
      end

      def attributes_for(game)
        game_system = Legacy::Importers::SystemBuilder.system.dup
        attributes = yield(game.forum_id)

        (1..10).each do |i|
          next unless name = attributes["attribute#{i}".to_sym]
          game_system[:sheet][:attributes_groups][ATTRIBUTES][:character_attributes].push(
            {
              name: name,
              abbreviation: attributes["abbreviation#{i}".to_sym].to_s,
              order: i,
              description: ''
            }
          )
        end

        game_system
      end

      def arenah_attributes(forum_id)
        @sheet_attributes.find { |attributes| attributes.forum_id == forum_id }
      end

      def daemon_attributes
        {
          attribute1: 'Força',
          attribute2: 'Constituição',
          attribute3: 'Destreza',
          attribute4: 'Agilidade',
          attribute5: 'Inteligência',
          attribute6: 'Força de vontade',
          attribute7: 'Percepção',
          attribute8: 'Carisma',
          abbreviation1: 'Fr',
          abbreviation2: 'Con',
          abbreviation3: 'Dex',
          abbreviation4: 'Agi',
          abbreviation5: 'Int',
          abbreviation6: 'Will',
          abbreviation7: 'Per',
          abbreviation8: 'Car'
        }
      end

      def replicate_sheet_to_characters
        @characters.each do |character|
          game = games.find { |game| game.id == character.forum_id }

          if game.present?
            puts "Saving system on #{character.name} - #{game.name}"
            save_character_sheet(character, game)
          else
            puts "Could not find data for #{character.name} on #{game.try(:name)}".red
          end
        end
      end

      def save_character_sheet(character, game)
        data = @sheet_data.find { |sheet_data| sheet_data.user_account_id == character.id }
        sheet = game.system.dup[:sheet][:attributes_groups]
        attributes = sheet[DATA][:character_attributes]

        attributes[0][:content] = character.name
        attributes[1][:content] = data.try(:xp) || 0
        attributes[2][:content] = ''
        attributes[3][:content] = data.try(:cash).to_i
        attributes[4][:content] = data.try(:level).to_i
        attributes[5][:content] = ''

        sheet_content = @sheets.find { |sheet| sheet.user_account_id == character.id }
        sheet[BACKGROUND][:character_attributes] = [{
          content: Parsers::Post.parse(sheet_content.try(:sheet).to_s)
        }]

        status = sheet[STATUS][:character_attributes]
        status[0][:total] = data.try(:total_life).to_i
        status[0][:points] = data.try(:life).to_i
        status[1][:total] = data.try(:total_mana).to_i
        status[1][:points] = data.try(:mana).to_i

        attributes = sheet[ATTRIBUTES][:character_attributes]
        (1..10).each do |index|
          attributes[index - 1][:points] = data.try(:public_send, "attribute#{index}").to_i
        end

        sheet = { attributes_groups: sheet }
        character.arenah_character.update(sheet: sheet.to_json)
      end
    end
  end
end
