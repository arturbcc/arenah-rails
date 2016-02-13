module RpgHelper
  def load_system
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    RPG::System.new(JSON.parse(json))
  end

  def load_sheet(game, character)
    json = File.read(File.join(Rails.root, "db/sheets/#{game}", "#{character}.json"))
    RPG::Sheet.new(JSON.parse(json))
  end
end

RSpec.configure do |config|
  config.include RpgHelper
end
