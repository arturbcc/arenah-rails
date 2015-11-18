module PostHelper
  def recipients_names(post)
    post.recipients.map(&:name).join(', ')
  end
end