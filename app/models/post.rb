# frozen_string_literal: true

class Post < ApplicationRecord
  PER_PAGE = 15

  belongs_to :topic
  belongs_to :character
  has_many :post_recipients
  has_many :recipients, through: :post_recipients, source: :character

  validates :topic_id, :message, presence: true
end
