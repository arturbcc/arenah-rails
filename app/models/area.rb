class Area
  def initialize(area = '')
    @area = area.to_sym
  end

  def panel?
    @area == :panel
  end

  def profile?
    @area == :profile
  end
end