require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe Game, type: :model do
  let(:game) { create(:game) }

  it_behaves_like 'a sluggable', 'resident-evil' do
    let(:sluggable) { game }
  end

  it { should have_many :topics }
  it { should have_many :topic_groups }
  it { should have_many :characters }
  it { should have_many :subscriptions }
  it { should validate_length_of :name }

  describe '#close!' do
    let(:user) { create(:user) }

    it 'changes the status of a game' do
      game.close!
      expect(game).to be_inactive
    end

    it 'removes the subscriptions when a game is closed' do
      Subscription.create!(user_id: user.id, game_id: game.id, status: 1)
      expect { game.close! }.to change { Subscription.all.count }.from(1).to(0)
    end
  end

  describe '#reopen!' do
    it 'changes the status of a game' do
      game = create(:game, :closed)
      game.reopen!
      expect(game).to be_active
    end
  end
end