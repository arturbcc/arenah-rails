require 'rails_helper'

describe PostRecipient, type: :model do
  it { should belong_to :post }
  it { should belong_to :character }
end