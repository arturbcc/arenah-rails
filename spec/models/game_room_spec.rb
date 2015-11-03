require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe GameRoom, type: :model do
  let(:game_room) { create(:game_room) }

  it_behaves_like 'a sluggable', 'resident-evil' do
    let(:sluggable) { game_room }
  end

  it { should have_many :topics }
  it { should have_many :characters }
  it { should have_many :subscriptions }
  it { should validate_length_of :name }

  describe '#close!' do
    let(:user) { create(:user) }

    it 'changes the status of a game room' do
      game_room.close!
      expect(game_room).to be_inactive
    end

    it 'removes the subscriptions when a game room is closed' do
      Subscription.create!(user_id: user.id, game_room_id: game_room.id, status: 1)
      expect { game_room.close! }.to change { Subscription.all.count }.from(1).to(0)
    end
  end

  describe '#reopen!' do
    it 'changes the status of a game room' do
      game_room.update(status: 0)
      game_room.reopen!
      expect(game_room).to be_active
    end
  end
end