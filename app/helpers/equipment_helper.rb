# frozen_string_literal: true

module EquipmentHelper
  SLOT_DICTIONARY = {
    'left-hand' => 'Mão esquerda',
    'right-hand' => 'Mão direita',
    'head' => 'Cabeça',
    'shoulder' => 'Ombro',
    'chest' => 'Tronco',
    'waist' => 'Cintura',
    'legs' => 'Pernas',
    'neck' => 'Pescoço',
    'feet' => 'Pés'
  }

  def equipment_image(game_slug, image_name, options = {})
    image_tag image_path(game_slug, image_name), options
  end

  def slot_name(slot)
    SLOT_DICTIONARY[slot.downcase]
  end

  private

  def image_path(game_slug, image_name)
    "/games/#{game_slug}/images/equipments/#{image_name}"
  end
end
