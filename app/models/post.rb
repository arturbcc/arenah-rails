class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :character

  validates_presence_of :topic_id, :message

  def from_character?(character_id)
    self.character_id == character_id
  end
  # Usar decorators para o método acima? O IsFromMaster também
end