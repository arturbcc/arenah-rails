class Area
  attr_reader :current

  def initialize(area = '')
    @current = area.to_sym
  end

  def panel?
    @current == :panel
  end

  def profile?
    @current == :profile
  end
end
