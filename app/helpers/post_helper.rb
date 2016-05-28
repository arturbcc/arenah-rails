# frozen_string_literal: true

module PostHelper
  def recipients_names(post)
    post.recipients.map(&:name).join(', ')
  end

  def recipients_ids(post)
    post.recipients.map(&:id).join(', ')
  end

  def keep_calm_image
    pic_number = rand(0..4) + 1
    image_tag "/images/keep-calm/keep-calm-#{pic_number}.png"
  end
end
