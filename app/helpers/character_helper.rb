# frozen_string_literal: true

module CharacterHelper
  def avatar(character, options = {})
    options = { alt: character.name, title: character.name }.merge(options)

    if character.avatar.present?
      image_tag avatar_path(character), options
    elsif character.female?
      image_tag female_avatar_path, options
    else
      image_tag male_avatar_path, options
    end
  end

  def avatar_path(character)
    "#{ENV['CDN_URL']}/games/#{character.game.slug}/images/avatars/#{character.avatar}"
  end

  private

  def male_avatar_path
    '/images/defaults/male.png'
  end

  def female_avatar_path
    '/images/defaults/female.png'
  end
end
