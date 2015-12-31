class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :character
  has_many :post_recipients
  has_many :recipients, through: :post_recipients, source: :character

  validates :topic_id, :message, presence: true
end
