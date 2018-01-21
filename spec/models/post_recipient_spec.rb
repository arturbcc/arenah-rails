# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostRecipient, type: :model do
  it { should belong_to :post }
  it { should belong_to :character }
end
