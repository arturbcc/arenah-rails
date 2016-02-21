# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe Topic, type: :model do
  it_behaves_like 'a sluggable', 'topic-title' do
    let(:sluggable) { Topic.create(game_id: 1, title: 'Topic Title') }
  end

  it { should have_many :posts }
  it { should belong_to :game }
  it { should validate_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :game_id }

  describe '.by_group_id' do
    it 'lists the topics from a group' do
      first_group = create(:topic_group)
      second_group = create(:topic_group)

      topic = create(:topic, topic_group: first_group, position: 2)
      create(:topic, topic_group: second_group)
      create(:topic, topic_group: second_group)
      other_topic = create(:topic, topic_group: first_group, position: 1)

      expect(described_class.by_group_id(first_group)).to eq([other_topic, topic])
    end
  end
end
