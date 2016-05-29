# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'Imports the Users to the new database format'
  task users: :environment do
    require 'rake-progressbar'
    require 'rake_tools'

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
      LegacyUser.build_from_row(row)
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

# 0 `UserId`, 1 `FullName`, 2 `Birth`, 3 `CityId`, 4 `SecretQuestion`, 5 `SecretAnswer`, 6 `Password`, 7 `Status`, 8 `ActivationCode`, 9 `RoleId`, 10 `Login`, 11 `NickName`, 12 `CountryId`,
# 13 `Sex`, 14 `ShowEmailAddress`, 15 `Avatar`, 16 `Url`, 17 `CreationDate`, 18 `IsSuperAdmin`, 19 `LastLoginDate`, 20 `Quotation`, 21 `ProfilePageView`, 22 `BeforeLastLoginDate`, 23 `InvitedByUserId`)
class LegacyUser
  NAME = 1
  BIRTH_DATE = 2
  PASSWORD = 6
  STATUS = 7
  EMAIL = 10
  CREATED_AT = 17

  attr_reader :name, :email

  def initialize(name:, password:, status:, email:, created_at:)
    @name = name
    @password = password
    @status = status
    @email = email
    @created_at = created_at
  end

  def active?
    @status
  end

  def invalid?
    !active? || @name == 'qa'
  end

  def self.build_from_row(row)
    LegacyUser.new(
      name: row[NAME],
      password: row[PASSWORD],
      status: row[STATUS] == 'A',
      email: row[EMAIL],
      created_at: Date.parse(row[CREATED_AT])
    )
  end

  def create!
    User.create!(
      email: @email,
      name: @name,
      password: generate_password,
      legacy_password: @password,
      confirmed_at: @created_at,
      created_at: @created_at,
      active: @active
    )
  end

  private

  def generate_password
    SecureRandom.uuid[0..7]
  end
end
