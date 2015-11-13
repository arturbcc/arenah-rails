class Ability
  attr_reader :identity, :character, :post

  def initialize(identity, post, character = nil)
    @identity = identity
    @character = character
    @post = post
  end

  def can_delete?
    identity.game_master? || author?
  end

  def can_edit?
    identity.game_master? || author?
  end

  def can_reply?
    identity.game_master? || recipient?
  end

  def author?
    return false if character.nil?

    post.character_id == character.id
  end

  def recipient?
    return false if character.nil?

    post.recipients.include?(character)
  end
end