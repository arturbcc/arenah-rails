# frozen_string_literal: true

require 'rake-progressbar'

require 'legacy/importers/assets_importer'
require 'legacy/importers/characters_importer'
require 'legacy/importers/game_masters_importer'
require 'legacy/importers/game_rooms_importer'
require 'legacy/importers/games_systems_importer'
require 'legacy/importers/posts_importer'
require 'legacy/importers/subscriptions_importer'
require 'legacy/importers/topic_groups_importer'
require 'legacy/importers/topics_importer'
require 'legacy/importers/users_importer'

require 'legacy/legacy_forum_moderator'
require 'legacy/report'

require 'legacy/rpg_system/legacy_character_sheet'
require 'legacy/rpg_system/legacy_sheet_attributes'
require 'legacy/rpg_system/legacy_sheet_data'

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
      create_games_systems

      remove_admin_test_game
      disable_old_medievalesca
      remove_unused_characters

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
      Legacy::Importers::PostsImporter.import(posts, topics, characters, games, user_partners, users)
    end

    def subscribe_characters
      Legacy::Importers::SubscriptionsImporter.import(characters, games, user_partners, moderators)
    end

    def build_game_folder_structure
      Legacy::Importers::AssetsImporter.new(characters).import
    end

    def create_games_systems
      Legacy::Importers::GamesSystemsImporter.new(
        games, characters, sheets, sheet_attributes, sheet_data).import
    end

    def remove_admin_test_game
      Game.find_by(name: 'Administração - o jogo').destroy
    end

    def disable_old_medievalesca
      game = Game.find_by(name: 'Medievalesca 1')
      game.characters.each do |character|
        character.update(status: 0)
      end
      game.update(status: 0)
    end

    def remove_unused_characters
      Character.where(name: 'Stölz Des Jager', post_count: 0).first.destroy
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

    def sheets
      @sheets ||= CSV.foreach(params[:sheets], CSV_OPTIONS).map do |row|
        Legacy::RpgSystem::LegacyCharacterSheet.build_from_row(row)
      end
    end

    def sheet_attributes
      @sheet_attributes ||= CSV.foreach(params[:sheet_attributes], CSV_OPTIONS).map do |row|
        Legacy::RpgSystem::LegacySheetAttributes.build_from_row(row)
      end
    end

    def sheet_data
      @sheet_data ||= CSV.foreach(params[:sheet_data], CSV_OPTIONS).map do |row|
        Legacy::RpgSystem::LegacySheetData.build_from_row(row)
      end
    end
  end
end
