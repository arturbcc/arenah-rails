class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :character
  has_many :post_recipients
  has_many :recipients, through: :post_recipients, source: :character
  # testar has_many :post_recipients, -> { joins(:characters).select('characters.id AS character_id, characters.name AS character_name') }

  validates :topic_id, :message, presence: true

  # def from_character?(character)
  #   return false if character.nil?

  #   character_id == character.id
  # end
end
