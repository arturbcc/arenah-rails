class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  # TODO: on delete, we must recount the post count of all characters
  has_many :posts, dependent: :delete_all
  belongs_to :topic_group

  validates :title, length: { maximum: 100 } #check the correct limit
  validates_presence_of :game_room_id, :slug
end
