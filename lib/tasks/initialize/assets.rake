require 'fileutils'

namespace :initialize do
  desc "Create the initial assets structure for the contents on the db:seed script"
  task :assets => :environment do
    FileUtils.copy_entry "#{Rails.root}/misc/games/", "#{Rails.root}/public/games/"
  end
end