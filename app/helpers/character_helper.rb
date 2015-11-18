module CharacterHelper
  def avatar(character, klass = 'avatar')
    if character.avatar.present?
      image_tag avatar_path(character), alt: character.name, title: character.name, class: klass
    elsif character.female?
      image_tag female_avatar_path, alt: character.name, title: character.name, class: klass
    else
      image_tag male_avatar_path, alt: character.name, title: character.name, class: klass
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