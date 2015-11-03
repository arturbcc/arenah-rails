require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe Character, type: :model do
  it_behaves_like 'a sluggable', 'new-character' do
    let(:sluggable) { Character.create(name: 'new character', game_room_id: 1) }
  end

  it { should have_many :posts }
  it { should validate_length_of :name }
  it { should validate_length_of :user_id }
  it { should validate_presence_of :game_room_id }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :type }
  it { should validate_presence_of :status }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :sheet_mode }
end