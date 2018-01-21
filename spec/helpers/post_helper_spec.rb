# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostHelper, type: :helper do
  context 'when listing recipients' do
    let(:user) { create(:user) }
    let(:master) { create(:character, user: user, name: 'Game Master') }
    let(:game) { create(:game, character: master) }
    let(:character1) { create(:character, name: 'Jane Roe', user: user, game: game) }
    let(:character2) { create(:character, name: 'John Doe', user: user, game: game) }
    let(:topic_group) { create(:topic_group, game: game) }
    let(:topic) { create(:topic, topic_group: topic_group, game_id: game.id) }
    let(:post) { create(:post, topic: topic, character: character1) }

    describe '#recipients_names' do
      context 'when post has no recipients' do
        it 'returns an empty string' do
          expect(helper.recipients_names(post)).to be_empty
        end
      end

      context 'when post has recipients' do
        it 'lists the names of the characters' do
          create(:post_recipient, post: post, character: character1)
          create(:post_recipient, post: post, character: character2)
          expect(helper.recipients_names(post)).to eq 'Jane Roe, John Doe'
        end
      end
    end

    describe '#recipients_ids' do
      context 'when post has no recipients' do
        it 'returns an empty string' do
          expect(helper.recipients_ids(post)).to be_empty
        end
      end

      context 'when post has recipients' do
        it 'lists the names of the characters' do
          create(:post_recipient, post: post, character: character1)
          create(:post_recipient, post: post, character: character2)
          expect(helper.recipients_ids(post)).to eq "#{character1.id}, #{character2.id}"
        end
      end
    end
  end
end
