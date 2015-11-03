class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates_presence_of :user_id, :game_id, :status
end