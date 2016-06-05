# frozen_string_literal: true

require 'legacy/legacy_character'
require 'legacy/legacy_user_partner'
module Legacy
  module Importers
    class GameMastersImporter
      def self.import(user_partners, users, characters, moderators)
        characters_count = Character.count

        puts '4. Creating game masters...'
        bar = RakeProgressbar.new(user_partners.count)

        moderators.each do |moderator|
          user_partner = user_partners.find { |user_partner| user_partner.id == moderator.user_id }

          user = users.find { |user| user.id == user_partner.user_id }
          character = user_partner.build_legacy_character(moderator.forum_id)
          character.create!(user.arenah_user)
          characters << character

          bar.inc
        end

        bar.finished
        total = Character.count
        puts "#{total - characters_count} characters created. Total: #{total}"
        puts ''
      end
    end
  end
end
