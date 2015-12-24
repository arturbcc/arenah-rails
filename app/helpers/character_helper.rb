module CharacterHelper
  def avatar(character, options = {})
    options = options.merge(alt: character.name, title: character.name)

    if character.avatar.present?
      image_tag avatar_path(character), options
    elsif character.female?
      image_tag female_avatar_path, options
    else
      image_tag male_avatar_path, options
    end
  end

  def avatar_path(character)
    "/games/#{character.game.slug}/images/avatars/#{character.avatar}"
  end

  private

  def male_avatar_path
    '/images/defaults/male.png'
  end

  def female_avatar_path
    '/images/defaults/female.png'
  end
end
