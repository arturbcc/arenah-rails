class Topic < ActiveRecord::Base
  has_many :posts

  validates :title, length: { maximum: 100 }
  validates :game_room_id, presence: true
end
