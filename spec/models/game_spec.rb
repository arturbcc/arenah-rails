# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { create(:user) }
  let(:character) { create(:character, user: user, name: 'Game owner and master') }
  let(:game) { create(:game, character: character) }

  it_behaves_like 'a sluggable', 'resident-evil' do
    let(:sluggable) { game }
  end

  it { should have_many :topic_groups }
  it { should have_many :characters }
  it { should have_many :subscriptions }
  it { should belong_to :character }
  it { should validate_length_of(:name).is_at_most(45) }
  it { should validate_length_of(:short_description).is_at_most(320) }

  describe '#close!' do
    it 'changes the status of a game' do
      game.close!
      expect(game).to be_inactive
    end

    it 'removes the subscriptions when a game is closed' do
      Subscription.create!(user: user, game: game, status: 1)
      expect { game.close! }.to change { Subscription.all.count }.from(1).to(0)
    end
  end

  describe '#reopen!' do
    it 'changes the status of a game' do
      game = create(:game, :closed, character: character)
      game.reopen!
      expect(game).to be_active
    end
  end

  context 'character types' do
    let!(:char1) { create(:character, game: game, user: user, name: 'John one') }
    let!(:char2) { create(:character, game: game, user: user, name: 'John two') }
    let!(:npc) { create(:character, :npc, game: game, user: user, name: 'Mister NPC') }
    let!(:master1) { create(:character, :game_master, game: game, user: user, name: 'game master 1') }

    describe '#pcs' do
      it 'lists only the pc\'s ordered by name' do
        expect(game.pcs).to eq([char1, char2])
      end
    end

    describe '#npcs' do
      it 'lists only the npc\'s ordered by name' do
        expect(game.npcs).to eq([npc])
      end
    end

    describe '#masters' do
      it 'lists only the masters ordered by name' do
        expect(game.masters).to match_array([character, master1])
      end
    end
  end
end
