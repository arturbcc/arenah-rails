class GameRoomSubscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_room

  validates_presence_of :user_id, :game_room_id, :status
end