class CharacterPost
  attr_reader :identity, :character, :post

  def initialize(identity, post, character = nil)
    @identity = identity
    @character = character
    @post = post
  end

  def author?
    return false if character.nil?

    post.character_id == character.id
  end

  def recipient?
    return false if character.nil?


  end

  def can_delete?
    identity.master? || author?
  end

  def can_edit?
    identity.master? || author?
  end
end