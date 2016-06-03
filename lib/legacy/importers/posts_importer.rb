# frozen_string_literal: true

require 'legacy/legacy_post'
module Legacy
  module Importers
    class PostsImporter
      def self.import(posts, topics, characters)
        puts '8. Creating posts...'
        bar = RakeProgressbar.new(posts.count)

        posts.each do |post|
          bar.inc

          next unless post.active?

          topic = topics.find { |topic| topic.id == post.topic_id }
          character = characters.find { |c| c.id == post.author_id }

          next unless topic && topic.arenah_topic
          post.create!(topic.arenah_topic, character.arenah_character)
        end

        bar.finished
        puts "#{Post.count} posts created"

        puts ''
      end
    end
  end
end
