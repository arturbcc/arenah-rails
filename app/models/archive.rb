# frozen_string_literal: true

class Archive
  def self.all
    Game.all.where(status: 0).order(:name)
  end
end
