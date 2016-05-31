# frozen_string_literal: true

namespace :import do
  desc 'Imports the Users to the new database format'
  task legacy: :environment do
    require 'csv'
    require 'colorize'
    require 'legacy/importer_params'
    require 'legacy/importer'

    params = Legacy::ImporterParams.new

    display_logo
    instructions

    unless params.valid_path?
      show_usage(params)
      exit 1
    end

    importer = Legacy::Importer.new(params.path_params)
    importer.start
  end

  def show_usage(params)
    puts 'USAGE: bin/rake import:legacy'
    puts ''
  end

  def display_logo
    puts ' █████╗ ██████╗ ███████╗███╗   ██╗ █████╗ ██╗  ██╗'.yellow
    puts '██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██║  ██║'
    puts '███████║██████╔╝█████╗  ██╔██╗ ██║███████║███████║'
    puts '██╔══██║██╔══██╗██╔══╝  ██║╚██╗██║██╔══██║██╔══██║'
    puts '██║  ██║██║  ██║███████╗██║ ╚████║██║  ██║██║  ██║'
    puts '╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝'
    puts ''
  end

  def instructions
    puts "**************************** Import database *******************************"
    puts '**                  Import data the new database format                   **'
    puts '**                                                                        **'
    puts '**  Make sure that:                                                       **'
    puts '**  1) The csv is separated by comma (,)                                  **'
    puts '**  2) The csv is encoded in UTF-8                                        **'
    puts '**                                                                        **'
    puts '**  All csv files must be under misc/csvs folder                          **'
    puts '**                                                                        **'
    puts '****************************************************************************'
    puts ''
  end
end
