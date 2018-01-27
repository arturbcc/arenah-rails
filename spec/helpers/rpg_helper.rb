# frozen_string_literal: true

module RpgHelper
  def load_system
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    Sheet::System.new(JSON.parse(json))
  end

  def load_sheet(game, character)
    load_raw_sheet(game, character)
    Sheet::Sheet.new(load_raw_sheet(game, character))
  end

  def load_raw_sheet(game, character)
    JSON.parse(File.read(File.join(Rails.root, "db/sheets/#{game}", "#{character}.json")))
  end
end

RSpec.configure do |config|
  config.include RpgHelper
end
