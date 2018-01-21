# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:user) { create(:user) }
  let(:system) { load_system }
  let(:character) { create(:character, user: user) }
  let(:game) { create(:game, system: system, character: character) }

  it_behaves_like 'a sluggable', 'topic-title' do
    let(:sluggable) { Topic.create(title: 'Topic Title', game_id: game.id) }
  end

  it { should have_many :posts }
  it { should belong_to :topic_group }
  it { should validate_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :game_id }

  describe '.by_group_id' do
    it 'lists the topics from a group' do
      first_group = create(:topic_group, game: game)
      second_group = create(:topic_group, game: game)

      topic = create(:topic, topic_group: first_group, position: 2, game_id: game.id)
      create(:topic, topic_group: second_group, game_id: game.id)
      create(:topic, topic_group: second_group, game_id: game.id)
      other_topic = create(:topic, topic_group: first_group, position: 1, game_id: game.id)

      expect(described_class.by_group_id(first_group)).to eq([other_topic, topic])
    end
  end
end
