# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, type: :model do
  let(:user) { create(:user) }

  it_behaves_like 'a sluggable', 'new-character' do
    let(:sluggable) { Character.create(name: 'new character', user: user) }
  end

  it { should have_many :posts }
  it { should validate_length_of(:name).is_at_most(100) }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :character_type }
  it { should validate_presence_of :status }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :sheet_mode }

  context 'messages' do
    let(:character1) { create(:character, user: user) }
    let(:character2) { create(:character, :game_master, user: user) }
    let(:message1) { create(:message, sender: character1, receiver: character2, created_at: 1.day.ago) }
    let(:message2) { create(:message, sender: character2, receiver: character1, created_at: 1.day.ago) }
    let(:message3) { create(:message, sender: character1, receiver: character2) }
    let(:message4) { create(:message, sender: character2, receiver: character1) }
    # TODO: fix arenah messages engine and uncomment these lines in this file
    # let(:message5) { create(:message, :sender_arenah, receiver: character1.id, created_at: 1.day.from_now) }

    describe '#sent_messages' do
      it 'lists all the messages a character sent, ordered by the most recent' do
        expect(character1.sent_messages).to eq([message3, message1])
      end
    end

    describe '#received_messages' do
      it 'lists all the messages a character received, ordered by the most recent' do
        # expect(character1.received_messages).to eq([message5, message4, message2])
        expect(character1.received_messages).to eq([message4, message2])
      end
    end
  end

  context '#sheet' do
    it 'loads the sheet' do
      sheet = load_sheet('crossover', 'inuyasha')
      inuyasha = Character.create!(user: user, name: 'Inuyasha', raw_sheet: sheet)

      expect(inuyasha.sheet.attributes_groups.count).to eq(10)
    end

    it 'loads the sheet with a system and applies table values on the groups' do
      user = create(:user)
      character = create(:character, user: user, name: 'Game owner and master')
      game = create(:game, raw_system: load_system, character: character)
      sheet = load_sheet('crossover', 'inuyasha')
      inuyasha = Character.create!(user: user, game: game, name: 'Inuyasha', raw_sheet: sheet)

      speed = inuyasha.sheet.find_character_attribute('Dados Extras', 'Velocidade')
      agility = inuyasha.sheet.find_character_attribute('Atributos', 'Agilidade')

      expect(speed.points.to_i).to eq(2)
    end
  end

  context '#update_sheet' do
    let(:sheet) { load_raw_sheet('crossover', 'inuyasha') }
    let(:character) { create(:character, user: user, raw_sheet: sheet) }

    context 'when group exists' do
      context 'and field name is `content`' do
        let(:changes) { [{ attribute_name: 'Nome', field_name: 'content', value: 'Jane Roe' }.stringify_keys] }

        it 'updates the database with the changes' do
          status = character.update_sheet('Dados', changes, [])
          expect(character.raw_sheet['attributes_groups'][0]['character_attributes'][0]['content']).to eq('Jane Roe')
          expect(status).to be_truthy
        end
      end

      context 'and field name is `point`' do
        let(:changes) { [{ attribute_name: 'Força', field_name: 'points', value: '21' }.stringify_keys] }

        it 'updates the database with the changes' do
          status = character.update_sheet('Atributos', changes, [])
          expect(character.raw_sheet['attributes_groups'][2]['character_attributes'][0]['points']).to eq(21)
          expect(status).to be_truthy
        end
      end

      context 'and field name is invalid' do
        let(:changes) { [{ attribute_name: 'Força', field_name: 'description', value: '1900' }.stringify_keys] }

        it 'does not update the database with the changes' do
          status = character.update_sheet('Atributos', changes, [])
          expect(character.raw_sheet).to eq(sheet)
          expect(status).to be_truthy
        end
      end

      context 'and there are items to delete' do
        let(:changes) { [] }

        it 'removes the attribute from the list' do
          attributes_group = character.raw_sheet['attributes_groups'][3]
          expect(attributes_group['character_attributes'].any? { |attribute| attribute['name'] == 'História' }).to be_truthy

          status = character.update_sheet('Perícias', changes, ['História'])
          character.reload

          attributes_group = character.raw_sheet['attributes_groups'][3]
          expect(attributes_group['character_attributes'].any? { |attribute| attribute['name'] == 'História' }).to be_falsy
          expect(status).to be_truthy
        end
      end
    end

    context 'when group does not exist' do
      it 'returns false' do
        status = character.update_sheet('Invalid Group', [], [])
        expect(status).to be_falsy
      end
    end
  end
end
