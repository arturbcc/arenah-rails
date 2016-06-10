# frozen_string_literal: true

require 'legacy/legacy_topic'
module Legacy
  module Importers
    class TopicsImporter
      def self.import(topics, games, characters)
        puts '7. Creating topics...'
        ignore_list = []
        positions = {}
        bar = RakeProgressbar.new(topics.count)

        topics.each do |topic|
          next if topic.topic_type == 1

          bar.inc
          game = games.find { |g| g.forum_id == topic.forum_id && g.valid? }
          group = game.try(:group_to_save_topics)

          if !game || !group
            ignore_list << "[#{topic.id}] #{topic.name}, de #{topic.author_name}"
            next
          end

          parent_forum_id = game.parent_forum_id
          game = games.find { |game| game.id == parent_forum_id } unless game.root?

          character = characters.find { |c| c.id == topic.author_id }
          positions[group.id] = 1 unless positions.include?(group.id)

          topic.create!(game.arenah_game, group, character.arenah_character, positions[group.id])

          positions[group.id] += 1
        end

        bar.finished
        reorder_topics

        puts "#{Topic.count} topics created"
        puts ''

        puts "#{ignore_list.count} topics ignored:"
        ignore_list.each { |topic| puts topic }

        puts ''
      end

      def self.reorder_topics
        puts ''
        Game.all.each do |game|
          game.topic_groups.each do |group|
            Topic.by_group_id(group.id).sort_by {|t| t.created_at}.reverse.each_with_index do |topic, index|
              topic.update(position: index + 1)
            end
          end
        end
        puts 'Topics reordered'
        puts ''
      end
    end
  end
end
