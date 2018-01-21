# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to :topic }
  it { should belong_to :character }
  it { should have_many :post_recipients }
  it { should have_many :recipients }
  it { should validate_presence_of :message }
  it { should validate_presence_of :topic_id }

  # describe '#from_character?' do
  #   let(:post) { Post.new(character_id: 10) }

  #   context 'invalid character' do
  #     it 'returns false' do
  #       expect(post.from_character?(nil)).to be false
  #     end
  #   end

  #   context 'valid character' do
  #     let(:character) { Character.new(id: 10) }

  #     it 'belongs to a character' do
  #       expect(post.from_character?(character)).to be true
  #     end

  #     it 'does not belong to a character' do
  #       character.id = 11
  #       expect(post.from_character?(character)).to be false
  #     end
  #   end
  # end

  describe '#recipients' do
    let(:user) { create(:user) }
    let(:system) { load_system }
    let(:character) { create(:character, user: user) }
    let(:game) { create(:game, system: system, character: character) }
    let(:topic_group) { create(:topic_group, game: game) }
    let(:topic) { create(:topic, topic_group: topic_group, game_id: game.id) }

    it 'lists all recipients of the post' do
      character1 = create(:character, name: 'Jane Roe', user: user, game: game)
      character2 = create(:character, user: user, game: game)
      post = create(:post, topic: topic, character: character)
      create(:post_recipient, post: post, character: character1)
      create(:post_recipient, post: post, character: character2)

      expect(post.recipients.count).to be 2
      expect(post.recipients).to include(character1)
      expect(post.recipients).to include(character2)
    end
  end
end
