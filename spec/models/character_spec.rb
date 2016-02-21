# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe Character, type: :model do
  it_behaves_like 'a sluggable', 'new-character' do
    let(:sluggable) { Character.create(name: 'new character', game_id: 1) }
  end

  it { should have_many :posts }
  it { should validate_length_of(:name).is_at_most(100) }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :character_type }
  it { should validate_presence_of :status }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :sheet_mode }

  context 'messages' do
    let(:user) { create(:user) }
    let(:character1) { create(:character, user: user) }
    let(:character2) { create(:character, :game_master, user: user) }
    let(:message1) { create(:message, from: character1.id, to: character2.id, created_at: 1.day.ago) }
    let(:message2) { create(:message, from: character2.id, to: character1.id, created_at: 1.day.ago) }
    let(:message3) { create(:message, from: character1.id, to: character2.id) }
    let(:message4) { create(:message, from: character2.id, to: character1.id) }
    let(:message5) { create(:message, :from_arenah, to: character1.id, created_at: 1.day.from_now) }

    describe '#sent_messages' do
      it 'lists all the messages a character sent, ordered by the most recent' do
        expect(character1.sent_messages).to eq([message3, message1])
      end
    end

    describe '#received_messages' do
      it 'lists all the messages a character received, ordered by the most recent' do
        expect(character1.received_messages).to eq([message5, message4, message2])
      end
    end
  end
end
