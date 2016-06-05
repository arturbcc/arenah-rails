# frozen_string_literal: true

require 'rake-progressbar'

require 'legacy/importers/assets_importer'
require 'legacy/importers/characters_importer'
require 'legacy/importers/game_masters_importer'
require 'legacy/importers/game_rooms_importer'
require 'legacy/importers/posts_importer'
require 'legacy/importers/subscriptions_importer'
require 'legacy/importers/topic_groups_importer'
require 'legacy/importers/topics_importer'
require 'legacy/importers/users_importer'

require 'legacy/legacy_forum_moderator'
require 'legacy/report'

module Legacy
  class Importer
    CSV_OPTIONS = { headers: false, col_sep: ',', encoding: 'UTF-8' }.freeze

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def start
      delete_records
      create_users
      create_characters
      create_game_masters
      create_game_rooms
      create_topic_groups
      create_topics
      create_posts

      subscribe_characters
      build_game_folder_structure

      # Copy avatars and banners
      # Create game system and set system on the characters
      # List games and characters

      Legacy::Report.new.show
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
      Legacy::Importers::UsersImporter.import(users)
    end

    def create_characters
      Legacy::Importers::CharactersImporter.import(characters, users)
    end

    def create_game_masters
      Legacy::Importers::GameMastersImporter.import(user_partners, users, characters, moderators, games)
    end

    def create_game_rooms
      Legacy::Importers::GameRoomsImporter.import(games, user_partners, characters)
    end

    def create_topic_groups
      Legacy::Importers::TopicGroupsImporter.import(games)
    end

    def create_topics
      Legacy::Importers::TopicsImporter.import(topics, games,characters)
    end

    def create_posts
      Legacy::Importers::PostsImporter.import(posts, topics, characters)
    end

    def subscribe_characters
      Legacy::Importers::SubscriptionsImporter.import(characters, games, user_partners, moderators)
    end

    def build_game_folder_structure
      Legacy::Importers::AssetsImporter.new(characters).import
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

    def moderators
      @moderators ||= CSV.foreach(params[:moderators], CSV_OPTIONS).map do |row|
        Legacy::LegacyForumModerator.build_from_row(row)
      end
    end
  end
end
