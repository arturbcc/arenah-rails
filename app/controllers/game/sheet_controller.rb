# frozen_string_literal: true

class Game::SheetController < Game::BaseController
  def show
    @character = Character.friendly.find(params[:character_slug])
    @game = @character.game
    @sheet = SheetPresenter.new(@character)

    render :show, layout: false
  end

  def update
    character = Character.friendly.find(params[:character_slug])

    if character
      group = character.sheet.find_attributes_group(params[:group_name])
      params[:character_attributes].each do |attribute_name, modified_item|
        character_attribute = character.sheet.find_character_attribute_on_group(group, attribute_name)
        character_attribute.public_send("#{modified_item[:field_name]}=", modified_item[:value])
      end

      character.update(sheet: character.sheet)

      head :ok
    else
      head :not_found
    end
  end
end
