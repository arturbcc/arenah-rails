class Identity
  VALID_ROLES = [:unlogged, :visitor, :player, :game_master]

  attr_reader :role

  def initialize(role = :unlogged)
    @role = current_role(role.to_sym) || :unlogged
  end

  def unlogged?
    role == :unlogged
  end

  def visitor?
    role == :visitor
  end

  def player?
    role == :player
  end

  def game_master?
    role == :game_master
  end

  def read_only?
    unlogged? || visitor?
  end

  def logged?
    visitor? || player? || game_master?
  end

  private

  def current_role(role)
    role if VALID_ROLES.include?(role)
  end
end
