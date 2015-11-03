require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe Topic, type: :model do
  it_behaves_like 'a sluggable', 'topic-title' do
    let(:sluggable) { Topic.create(game_room_id: 1, title: 'Topic Title') }
  end

  it { should have_many :posts }
  it { should validate_length_of :title }
  it { should validate_presence_of :game_room_id }
end