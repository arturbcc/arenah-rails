require 'rails_helper'

RSpec.describe Archive, type: :model do
  let(:user) { create(:user) }
  let(:character) { create(:character, user: user, name: 'Game owner and master') }
  let!(:resident) { create(:game, name: 'dungeon and dragons', character: character) }
  let!(:closed_game) { create(:game, :closed, character: character) }

  it 'lists all archived games' do
    expect(Archive.all.map(&:name)).to eq([closed_game.name])
  end
end
