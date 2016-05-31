require 'rake-progressbar'
require 'legacy/legacy_user'
require 'legacy/legacy_character'
require 'legacy/legacy_game'

module Legacy
  class Importer
    CSV_OPTIONS = { headers: false, col_sep: ',', encoding: 'UTF-8' }.freeze

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def start
      User.transaction do
        delete_records
        create_users
        create_characters
        create_game_rooms

        # Import game rooms
        # Create folder structure for the game
        # Copy avatars and banners
        # Create game system and set system on the characters
        # Set game on the characters
        # Import subforuns, topics and posts
      end
    end

    private

    def delete_records
      puts '1. Deleting existing records... '
      User.delete_all
      Character.delete_all
    end

    def create_users
      puts '2. Creating users...'
      bar = RakeProgressbar.new(users.count)
      users.each do |user|
        next if user.invalid?

        user.create!
        bar.inc
      end

      bar.finished
      puts "#{User.count} users created"
    end

    def create_characters
      puts '3. Creating characters...'
      bar = RakeProgressbar.new(characters.count)
      characters.each do |character|
        user = users.find { |user| user.id == character.user_id }
        character.create!(user.arenah_user)

        bar.inc
      end

      bar.finished
      puts "#{Character.count} characters created"
    end

    def create_game_rooms
      puts '4. Creating game rooms...'
      bar = RakeProgressbar.new(games.count)
      games.each do |game|
        character = characters.find { |character| character.user_partner_id == game.author_id }
        game.create!(character.arenah_character)

        bar.inc
      end

      bar.finished
      puts "#{Game.count} games created"
    end

    def users
      @users ||= CSV.foreach(params[:users], CSV_OPTIONS).map do |row|
        Legacy::LegacyUser.build_from_row(row)
      end
    end

    def characters
      @characters ||= CSV.foreach(params[:characters], CSV_OPTIONS).map do |row|
        Legacy::LegacyCharacter.build_from_row(row)
      end
    end

    def games
      @games ||= CSV.foreach(params[:games], CSV_OPTIONS).map do |row|
        Legacy::LegacyGame.build_from_row(row)
      end
    end
  end
end
