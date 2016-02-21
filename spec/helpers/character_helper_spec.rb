# frozen_string_literal: true

require 'rails_helper'

describe CharacterHelper do
  describe '#avatar' do
    context 'with avatar' do
      let(:character) { build(:character, avatar: 'avatar.png', game: build(:game)) }

      it 'builds the avatar' do
        expect(helper.avatar(character)).to include(character.avatar)
      end
    end

    context 'without avatar' do
      it 'builds a male avatar' do
        character = build(:character)
        expect(helper.avatar(character)).to include('male.png')
      end

      it 'builds a female avatar' do
        character = build(:character, :female)
        expect(helper.avatar(character)).to include('male.png')
      end
    end

    context 'with extra class' do
      it 'adds a custom class' do
        character = build(:character)
        expect(helper.avatar(character, class: 'custom')).to include('class="custom"')
      end
    end
  end
end
