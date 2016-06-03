# frozen_string_literal: true

require 'rake-progressbar'
require 'legacy/legacy_user'
require 'legacy/legacy_character'
require 'legacy/legacy_game'
require 'legacy/legacy_user_partner'
require 'legacy/legacy_topic'
require 'legacy/legacy_post'

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
        create_topics
        create_posts

        # Set game on the characters
        # Create folder structure for the game
        # Copy avatars and banners
        # Create game system and set system on the characters
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
      Post.delete_all
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

        character.create!(user.arenah_user)
        characters << character

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
        subforums = games.select { |g| g.parent_forum_id == game.id && g.valid? }

        if subforums.count <= 2
          #create two group with the name of the subforums and one "geral"

          index = 1
          subforums.each do |forum|
            forum.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: truncate(forum.title), position: index)
            puts "  Group '#{forum.title}' created at position #{index}"
            index += 1
          end

          game.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: 'Geral', position: index)
          puts "  Group 'Geral' created at position #{index}"
        elsif subforums.count == 3
          #create three groups with the name of the subforums and send general topics to the last one

          subforums.each_with_index do |forum, index|
            forum.group_to_save_topics = TopicGroup.create!(game: game.arenah_game, name: truncate(forum.title), position: index + 1)
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

    def create_topics
      puts '7. Creating topics...'
      ignore_list = []
      positions = {}

      topics.each do |topic|
        game = games.find { |g| g.forum_id == topic.forum_id && g.valid? }
        group = game.group_to_save_topics

        if !game || !group
          ignore_list << "[#{topic.id}] #{topic.name}, de #{topic.author_name}"
          next
        end

        parent_forum_id = game.parent_forum_id
        game = games.find { |game| game.id == parent_forum_id } unless game.root?

        puts "Saving #{topic.name} on #{group.name}"

        character = characters.find { |c| c.id == topic.author_id }
        positions[group.id] = 1 unless positions.include?(group.id)

        topic.create!(game.arenah_game, group, character.arenah_character, positions[group.id])

        positions[group.id] += 1
      end

      puts "#{Topic.count} topics created"
      puts ''

      puts "#{ignore_list.count} topics ignored:"
      ignore_list.each { |topic| puts topic }

      puts ''
    end

    def create_posts
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

    def topics
      @topics ||= CSV.foreach(params[:topics], CSV_OPTIONS).map do |row|
        Legacy::LegacyTopic.build_from_row(row)
      end
    end

    def posts
      @posts ||= CSV.foreach(params[:posts], CSV_OPTIONS).map do |row|
        Legacy::LegacyPost.build_from_row(row)
      end
    end

    def truncate(str, length = 20)
      return str if str.length <= length

      str[0..length - 4] + '...'
    end
  end
end
