require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe User, type: :model do
  it { should have_many :characters }
  it { should have_many :subscriptions }
  it { should validate_length_of :name }
  it { should validate_presence_of :name }
  it { should validate_presence_of :password }

  it_behaves_like 'a sluggable', 'john-doe' do
    let(:sluggable) { create(:user) }
  end
end
