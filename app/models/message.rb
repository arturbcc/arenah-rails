require 'html/sanitizer'

class Message < ActiveRecord::Base
  def excerpt(length)
    content = HTML::FullSanitizer.new.sanitize(body)
    content.truncate(length)
  end
end
