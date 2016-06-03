# frozen_string_literal: true

module Legacy
  module Importers
    class UsersImporter
      def self.import(users)
        puts '2. Creating users...'
        bar = RakeProgressbar.new(users.count)
        users.each do |user|
          next if user.invalid?

          user.create!
          bar.inc
        end

        bar.finished
        puts "#{User.count} users created"
        puts ''
      end
    end
  end
end
