# frozen_string_literal: true

require 'fileutils'
require 'open-uri'
require 'colorize'
require 'uri'
module Legacy
  module Importers
    class AssetsImporter
      PATH = '/tmp/imported_data'.freeze
      ORIGINAL_ASSETS_URL = 'http://www.rpg.arenah.com.br'

      attr_reader :characters

      def initialize(characters)
        @characters = characters
      end

      def import
        puts '11. Copying assets...'
        create_initial_folder
        copy_assets
        puts ''
      end

      private

      def create_initial_folder
        path = File.join(Rails.root, PATH)

        if File.directory?(path)
          puts "#{path} already exists. Deleting it."
          FileUtils.rm_rf(path)
        end

        Dir.mkdir(path)
        puts "#{path} created"
      end

      def copy_assets
        games = Game.all

        games.sort_by(&:name).each do |game|
          create_folders(game)
          create_css(game)
          copy_avatars(game)
          copy_banner(game)
        end
      end

      def create_folders(game)
        path = File.join(Rails.root, PATH, game.slug)

        unless File.directory?(path)
          Dir.mkdir(path)
          Dir.mkdir(File.join(path, 'css'))
          Dir.mkdir(File.join(path, 'images'))
          Dir.mkdir(File.join(path, 'images', 'avatars'))
          Dir.mkdir(File.join(path, 'images', 'banners'))
          Dir.mkdir(File.join(path, 'images', 'equipments'))
        end
      end

      def create_css(game)
        path = File.join(Rails.root, PATH, game.slug, 'css', 'custom.css')
        FileUtils.touch(path)
      end

      def copy_avatars(game)
        puts ''
        puts "Copying avatars for game #{game.name.yellow}"
        path = File.join(Rails.root, PATH, game.slug, 'images', 'avatars')

        if game.characters.count == 0
          puts "Something seems #{'wrong'.red}. There are #{'no characters'.red} in this game."
        end

        game.characters.each do |character|
          unless avatar?(character)
            puts "Using default avatar for #{character.name}"
            next
          end

          current_avatar = avatar(character)
          extension = File.extname(current_avatar)
          download_path = URI.join(ORIGINAL_ASSETS_URL, '/resources/avatar/', current_avatar)
          puts "Downloading #{download_path}"

          begin
            open("#{path}/#{character.slug}#{extension}", 'wb') do |file|
              file << open(download_path).read
            end
          rescue
            puts "Could not download avatar for #{character.slug}".red
            character.update(avatar: nil)
          end
        end
      end

      def avatar?(character)
        legacy_character = characters.find { |char| char.arenah_character.id == character.id }

        legacy_character.has_avatar?
      end

      def avatar(character)
        legacy_character = characters.find { |char| char.arenah_character.id == character.id }

        legacy_character.avatar
      end

      def copy_banner(game)
        return unless game.banner

        puts ''
        puts 'Copying banner'
        path = File.join(Rails.root, PATH, game.slug, 'images', 'banners')
        download_path = URI.join(ORIGINAL_ASSETS_URL, '/resources/banners/rooms/', URI.encode(game.banner))
        extension = File.extname(game.banner)
        puts "Downloading #{download_path}"

        begin
          open("#{path}/main-banner#{extension}", 'wb') do |file|
            file << open(download_path).read
          end
          game.update(banner: "main-banner#{extension}")
        rescue
          puts "Could not download banner for #{game.name}".red
          game.update(banner: nil)
        end
      end
    end
  end
end
