require 'rake-progressbar'
require 'legacy/legacy_user'
require 'legacy/legacy_character'

module Legacy
  class Importer
    CSV_OPTIONS = { headers: false, col_sep: ',', encoding: 'UTF-8' }.freeze

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def start
      User.transaction do
        puts '1. Deleting existing records... '
        User.delete_all

        puts "2. Importing data from #{params[:users]}..."
        users = load_users

        puts '3. Creating users...'
        bar = RakeProgressbar.new(users.count)
        users.each do |user|
          next if user.invalid?

          bar.inc
          user.create!
        end

        bar.finished
        puts "#{User.count} users created"

        puts '4. Creating characters...'

        # Import characters
        # Import game rooms
        # Create folder structure for game
        # Copy avatars and banners
        # Create game system
        # Import subforuns, topics and posts
      end
    end

    private

    def load_users
      CSV.foreach(params[:users], CSV_OPTIONS).map do |row|
        Legacy::LegacyUser.build_from_row(row)
      end
    end

    def load_characters
      CSV.foreach(params[:characters], CSV_OPTIONS).map do |row|
        Legacy::LegacyCharacter.build_from_row(row)
      end
    end
  end
end
