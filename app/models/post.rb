class Post < ActiveRecord::Base
  belongs_to :topic

  validates :topic_id, presence: true
  validates :message, presence: true

  def from_character?(character_id)
    self.character_id == character_id
  end
  # Usar decorators para o método acima? O IsFromMaster também
end