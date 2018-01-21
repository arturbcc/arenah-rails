# frozen_string_literal: true

class PostRecipient < ApplicationRecord
  belongs_to :post
  belongs_to :character
end
