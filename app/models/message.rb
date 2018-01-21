# frozen_string_literal: true

# require 'html/sanitizer'

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Character', foreign_key: :from
  belongs_to :receiver, class_name: 'Character', foreign_key: :to

  # FROM_ARENAH = 0

  def excerpt(length)
    content = Rails::Html::FullSanitizer.new.sanitize(body)
    content.truncate(length)
  end
end
