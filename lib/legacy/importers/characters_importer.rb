# frozen_string_literal: true

require 'legacy/legacy_character'
require 'legacy/legacy_user'
module Legacy
  module Importers
    class CharactersImporter
      def self.import(characters, users)
        puts '3. Creating characters...'
        bar = RakeProgressbar.new(characters.count)
        characters.each do |character|
          user = users.find { |user| user.id == character.user_id }
          character.create!(user.arenah_user)

          bar.inc
        end

        bar.finished
        puts "#{Character.count} characters created"
        puts "#{Character.where(status: 1).count} active characters"
        puts "#{Character.where(status: 0).count} inactive characters"
        puts ''
      end
    end
  end
end
