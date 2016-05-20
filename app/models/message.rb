# frozen_string_literal: true

# require 'html/sanitizer'

class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'Character'
  belongs_to :receiver, class_name: 'Character'

  FROM_ARENAH = 0

  def excerpt(length)
    content = Rails::Html::FullSanitizer.new.sanitize(body)
    content.truncate(length)
  end
end
