require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe GameRoom, type: :model do
  it_behaves_like 'a sluggable', 'new-game-room' do
    let(:sluggable) { GameRoom.create(name: 'new Game Room') }
  end

  it { should have_many :topics }
  it { should have_many :characters }
  it { should validate_length_of :name }
end
