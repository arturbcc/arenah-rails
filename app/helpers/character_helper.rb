module CharacterHelper
  def avatar(character)
    if character.avatar.present?
      image_tag avatar_path(character), alt: character.name, title: character.name
    elsif character.female?
      image_tag female_avatar_path, alt: character.name, title: character.name
    else
      image_tag male_avatar_path, alt: character.name, title: character.name
    end
  end

  private

  def avatar_path(character)
    "/games/#{character.game.slug}/images/avatars/#{character.avatar}"
  end

  def male_avatar_path
    '/images/defaults/male.png'
  end

  def female_avatar_path
    '/images/defaults/female.png'
  end
end