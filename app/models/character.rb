class Character < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  enum status: { inactive: 0, active: 1 }
  enum character_type: { pc: 0, npc: 1, game_master: 2 }
  enum gender:  { male: 0, female: 1 }
  enum sheet_mode: { freemode: 0, gamemode: 1 }

  belongs_to :user
  belongs_to :game
  has_many :posts

  validates :name, :user_id, :slug, :character_type, :status, :gender, :sheet_mode, presence: true
end
