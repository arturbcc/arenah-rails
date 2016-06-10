# frozen_string_literal: true

module Legacy
  module Importers
    class TopicGroupsImporter
      def self.import(games)
        puts '6. Creating topic group...'

        root_games = games.select { |game| game.root? }
        root_games.each do |game|
          next unless game.game_room?

          puts "* #{game.name}"
          subforums = games.select { |g| g.parent_forum_id == game.id && g.valid? }

          if subforums.count <= 2
            #create two group with the name of the subforums and one "geral"

            index = 1
            subforums.each do |forum|
              forum.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: forum.truncate(forum.title), position: index)
              puts "  Group '#{forum.title}' created at position #{index}"
              index += 1
            end

            game.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: 'Geral', position: index)
            puts "  Group 'Geral' created at position #{index}"
          elsif subforums.count == 3
            #create three groups with the name of the subforums and send general topics to the last one

            subforums.each_with_index do |forum, index|
              forum.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: forum.truncate(forum.title), position: index + 1)
              puts "  Group '#{forum.title}' created at position #{index + 1}"
            end
            game.group_to_save_topics = subforums[2].group_to_save_topics
          else
            #create two groups: "geral" and "jogo"

            game.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: 'Geral', position: 1)
            puts "  Group 'Geral' created at position 1"
            group = TopicGroup.create!(game: game.arenah_game, name: 'Jogo', position: 2)
            subforums.each { |forum| forum.group_to_save_topics = group }
            puts "  Group 'Jogo' created at position 2"
          end

          puts ''
        end
      end
    end
  end
end
