# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'Imports the Users to the new database format'
  task users: :environment do
    require 'rake-progressbar'
    require 'rake_tools'
    require 'legacy/legacy_user'

    RakeTools.display_logo
    show_disclaimer

    CSV_OPTIONS = { headers: false, col_sep: ',', encoding: 'UTF-8' }.freeze

    unless valid_path?
      show_usage
      exit 1
    end

    User.transaction do
      puts '1. Deleting existing records... '
      User.delete_all

      puts "2. Importing data from #{path_params[:users]}..."
      users = load_users

      puts "3. Creating users..."
      bar = RakeProgressbar.new(users.count)
      users.each do |user|
        next if user.invalid?

        bar.inc
        user.create!
      end

      bar.finished

      puts "#{User.count} users created"
    end
  end

  def load_users
    CSV.foreach(path_params[:users], CSV_OPTIONS).map do |row|
      Legacy::LegacyUser.build_from_row(row)
    end
  end

  def path_params
    @path_params ||= {
      users: ENV.fetch('USERS_PATH', 'users.csv')
    }
  end

  def valid_path?
    File.file?(path_params[:users])
  end

  def show_usage
    puts "USAGE: bin/rake import:users USERS_PATH='path/to/users.csv'"
    puts ''
  end

  def show_disclaimer
    RakeTools.instructions(
      title: '',
      description: ''
    )

    RakeTools.heroku_command('import:users', "USERS_PATH=#{path_params[:users]}")
  end
end
