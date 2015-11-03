require 'rails_helper'

describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :game_room }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :game_room_id }
  it { should validate_presence_of :status }
end