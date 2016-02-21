# frozen_string_literal: true

class PostRecipient < ActiveRecord::Base
  belongs_to :post
  belongs_to :character
end
