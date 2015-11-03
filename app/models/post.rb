class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :character

  validates_presence_of :topic_id, :message

  def from_character?(character_id)
    self.character_id == character_id
  end
  # TODO: should we use decorators for the from_character? method? Is_from_master is also another candidate.
end