require 'rake-progressbar'
require 'legacy/legacy_user'
require 'legacy/legacy_character'
require 'legacy/legacy_game'
require 'legacy/legacy_user_partner'

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
        create_game_masters
        create_game_rooms
        create_topic_groups

        # Import subforuns
        # Import topics
        # Import posts
        # Create folder structure for the game
        # Copy avatars and banners
        # Create game system and set system on the characters
        # Set game on the characters
      end
    end

    private

    def delete_records
      puts '1. Deleting existing records... '
      User.delete_all
      Character.delete_all
      Game.delete_all
      TopicGroup.delete_all
      Topic.delete_all
      puts ''
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
      puts ''
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
      puts ''
    end

    def create_game_masters
      characters_count = Character.count

      puts '4. Creating game masters...'
      bar = RakeProgressbar.new(user_partners.count)

      user_partners.each do |user_partner|
        next if user_partner.invalid?

        character = user_partner.build_legacy_character
        user = users.find { |user| user.id == user_partner.user_id }

        characters << character
        debugger if user.arenah_user.nil?
        character.create!(user.arenah_user)

        bar.inc
      end

      bar.finished
      total = Character.count
      puts "#{total - characters_count} characters created. Total: #{total}"
      puts ''
    end

    def create_game_rooms
      puts '5. Creating game rooms...'
      bar = RakeProgressbar.new(games.count)
      root_games = games.select { |game| game.root? }

      root_games.each do |game|
        next unless game.game_room?

        user_partner = user_partners.find { |user| user.id == game.author_id }
        character = characters.find { |character| character.user_partner_id == user_partner.id }
        game.create!(character.arenah_character)

        bar.inc
      end

      bar.finished
      puts "#{Game.count} games created"
      puts ''
    end

    def create_topic_groups
      puts '6. Creating topic group...'

      root_games = games.select { |game| game.root? }
      root_games.each do |game|
        next unless game.game_room?

        puts "* #{game.name}"
        subforums = games.select { |g| g.parent_forum_id == game.id && g.active? }

        if subforums.count <= 2
          #create two group with the name of the subforums and one "geral"

          index = 1
          subforums.each do |forum|
            TopicGroup.create!(game: game.arenah_game, name: truncate(forum.title), position: index)
            puts "  Group '#{forum.title}' created at position #{index}"
            index += 1
          end

          TopicGroup.create!(game: game.arenah_game, name: 'Geral', position: index)
          puts "  Group 'Geral' created at position #{index}"
        elsif subforums.count == 3
          #create three groups with the name of the subforums and send general topics to the first one

          subforums.each_with_index do |forum, index|
            TopicGroup.create!(game: game.arenah_game, name: truncate(forum.title), position: index + 1)
            puts "  Group '#{forum.title}' created at position #{index + 1}"
          end
        else
          #create two groups: "geral" and "jogo"

          TopicGroup.create!(game: game.arenah_game, name: 'Geral', position: 1)
          puts "  Group 'Geral' created at position 1"
          TopicGroup.create!(game: game.arenah_game, name: 'Jogo', position: 2)
          puts "  Group 'Jogo' created at position 2"
        end

        puts ''
      end
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

    def user_partners
      @user_partners ||= CSV.foreach(params[:user_partners], CSV_OPTIONS).map do |row|
        Legacy::LegacyUserPartner.build_from_row(row)
      end
    end

    def games
      @games ||= CSV.foreach(params[:games], CSV_OPTIONS).map do |row|
        Legacy::LegacyGame.build_from_row(row)
      end
    end

    def truncate(str, length = 20)
      return str if str.length <= length

      str[0..length - 4] + '...'
    end
  end
end
