# frozen_string_literal: true

require 'colorize'

module Legacy
  class ImporterTools
    def self.display_logo
      puts " █████╗ ██████╗ ███████╗███╗   ██╗ █████╗ ██╗  ██╗".yellow
      puts "██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██║  ██║"
      puts "███████║██████╔╝█████╗  ██╔██╗ ██║███████║███████║"
      puts "██╔══██║██╔══██╗██╔══╝  ██║╚██╗██║██╔══██║██╔══██║"
      puts "██║  ██║██║  ██║███████╗██║ ╚████║██║  ██║██║  ██║"
      puts "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝"
      puts ""
    end

    def self.instructions
      puts "**************************** Import database *******************************"
      puts '**                  Import data the new database format                   **'
      puts '**                                                                        **'
      puts '**  Make sure that:                                                       **'
      puts '**  1) The csv is separated by comma (,)                                  **'
      puts '**  2) The csv is encoded in UTF-8                                        **'
      puts '**                                                                        **'
      puts '****************************************************************************'
      puts ''
    end

    def self.heroku_command(rake_name, *args)
      commands = [
        'DISABLE_SPRING=1',
        'DATABASE_URL=`heroku config:get DATABASE_URL`',
        "bin/rake #{rake_name}"
      ]
      commands += args

      puts 'To run this rake on Heroku, run:'
      puts commands.join(' ')
      puts ''
    end
  end
end
