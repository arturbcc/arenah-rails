# frozen_string_literal: true

module PostHelper
  def recipients_names(post)
    post.recipients.map(&:name).join(', ')
  end

  def recipients_ids(post)
    post.recipients.map(&:id).join(', ')
  end
end
