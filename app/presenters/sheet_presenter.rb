class SheetPresenter
  attr_reader :character

  def initialize(character)
    @character = character
  end

  def system
    @system ||= character.game.system
  end

  def pages
    @pages ||= system.sheet.pages.sort_by {|page| page.number }
  end

  def header_attributes(page:)
    @header_attributes ||= character.sheet.attributes_groups_by(page: page, position: 'header')
  end

  def column_attributes(page:, column:)
    character.sheet.attributes_groups_by(page: page, position: "column_#{column}")
  end

  def footer_attributes(page:)
    @footer_attributes ||= character.sheet.attributes_groups_by(page: page, position: 'footer')
  end
end
