# frozen_string_literal: true

require 'legacy/importers/system_builder'
module Legacy
  module Importers
    class GamesSystemsImporter
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
        game_system = Legacy::Importers::SystemBuilder.system
        attributes = yield(game.forum_id)

        (1..10).each do |i|
          game_system[:sheet][:attributes_groups][ATTRIBUTES][:character_attributes].push(
            {
              name: attributes["attribute#{i}".to_sym] || "atributo #{i}",
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
          game = game_for(character)
          data = @sheet_data.find { |sheet_data| sheet_data.user_account_id == character.id }

          unless game.present?
            puts "Could not find data for #{character.name} on #{game.try(:name)}".red
            next
          end

          unless data.present?
            character.arenah_character.update(sheet: default_sheet(game, character))
            puts "Saving default data for #{character.name} on #{game.try(:name)}".yellow
            next
          end

          puts "Saving system on #{character.name} - #{game.name}"
          sheet = game.system.dup[:sheet][:attributes_groups]
          attributes = sheet[ATTRIBUTES][:character_attributes]

          attributes[0][:content] = character.name
          attributes[1][:content] = data.xp
          attributes[3][:content] = data.cash.to_i
          attributes[4][:content] = data.level.to_i

          # background = sheet[BACKGROUND][:character_attributes]
          sheet_content = @sheets.find { |sheet| sheet.user_account_id == character.id }
          sheet[BACKGROUND][:character_attributes] = [{
            content: Parsers::Post.parse(sheet_content.try(:sheet).to_s)
          }]

          status = sheet[STATUS][:character_attributes]
          status[0][:total] = data.total_life
          status[0][:points] = data.life
          status[1][:total] = data.total_mana
          status[1][:points] = data.mana

          sheet = { attributes_groups: sheet }
          character.arenah_character.update(sheet: sheet.to_json)
        end
      end

      def game_for(character)
        games.find { |game| game.id == character.forum_id }
      end

      def default_sheet(game, character)
        sheet = game.system.dup[:sheet][:attributes_groups]
        background = sheet[BACKGROUND][:character_attributes]
        background = { content:'' }

        status = sheet[STATUS][:character_attributes]
        status[0][:total] = 0
        status[0][:points] = 0
        status[1][:total] = 0
        status[1][:points] = 0

        { attributes_groups: sheet }
      end
    end
  end
end
