class ToursController < ApplicationController
  before_action :set_identity, :set_area

  def for_masters
  end

  def for_players
  end

  private

  def set_identity
    @identity = Identity.new(:visitor)
  end

  def set_area
    @area = Area.new(:tours)
  end
end
