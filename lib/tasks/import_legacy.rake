# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'Imports the Users to the new database format'
  task legacy: :environment do
    require 'legacy/importer_tools'
    require 'legacy/importer_params'
    require 'legacy/importer'

    params = Legacy::ImporterParams.new

    show_disclaimer

    unless params.valid_path?
      show_usage(params)
      exit 1
    end

    importer = Legacy::Importer.new(params.path_params)
    importer.start
  end

  def show_usage(params)
    puts "USAGE: bin/rake import:legacy #{params.to_usage_params}"
    puts ''
  end

  def show_disclaimer
    Legacy::ImporterTools.display_logo
    Legacy::ImporterTools.instructions

    # Legacy::ImporterTools.heroku_command(
    #   'import:legacy',
    #   "USERS_PATH=#{path_params[:users]}"
    # )
  end
end
