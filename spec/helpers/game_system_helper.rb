module GameSystemHelper
  def load_system
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    @system = RPG::System.new(JSON.parse(json))
  end
end

RSpec.configure do |config|
  config.include GameSystemHelper
end
