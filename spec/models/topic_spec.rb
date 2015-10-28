require 'rails_helper'

describe Topic, type: :model do
  it { should have_many :posts }
  it { should validate_length_of :title }
  it { should validate_presence_of :game_room_id }
end
