require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe User, type: :model do
  it { should have_many :characters }
  it { should validate_length_of :name }
  it { should validate_length_of :nickname }
  it { should validate_presence_of :name }
  it { should validate_presence_of :nickname }
  it { should validate_presence_of :password }

  it_behaves_like 'a sluggable', 'user-nickname' do
    let(:sluggable) { User.create(name: 'user', nickname: 'User Nickname', password: 'X03MO1qnZdYdgyfeuILPmQ==') }
  end
end
