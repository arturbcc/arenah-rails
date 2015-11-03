require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe TopicGroup, type: :model do
  it_behaves_like 'a sluggable', 'topic-group-name' do
    let(:sluggable) { TopicGroup.create(game_room_id: 1, name: 'Topic Group Name') }
  end

  it { should have_many :topics }
  it { should validate_length_of :name }
  it { should validate_presence_of :game_room_id }
  it { should validate_presence_of :name }
end