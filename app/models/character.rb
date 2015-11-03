class Character < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  #http://stackoverflow.com/questions/75759/enums-in-ruby
  # enum status_type: [:inactive, :active]
  # enum character_type: [:pc, :npc, :game_master]
  # enum gender_type: [:male, :female]
  # enum sheet_status_type: [:freemod, :on]

  belongs_to :user
  belongs_to :game_room
  has_many :posts

  validates_presence_of :name, :user_id, :game_room_id, :slug, :type, :status, :gender, :sheet_mode
end