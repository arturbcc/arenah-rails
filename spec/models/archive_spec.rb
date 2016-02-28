require 'rails_helper'

describe Archive do
  let!(:resident) { create(:game, name: 'dungeon and dragons') }
  let!(:closed_game) { create(:game, :closed) }

  it 'lists all archived games' do
    expect(Archive.all.map(&:name)).to eq([closed_game.name])
  end
end
