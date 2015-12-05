class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates :user_id, :game_id, :status, presence: true
end
