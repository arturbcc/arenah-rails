# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::BaseController, type: :controller do
  let(:owner_user) { create(:user, name: 'Game Owner') }
  let(:character) { create(:character, user: owner_user) }
  let!(:game) { create(:game, character: character) }
  let(:user) { create(:user, name: 'John Doe') }

  describe '#set_identity' do
    before do
      allow(controller).to receive(:current_user) { user }
    end

    context 'when current game is not set' do
      it 'detects unlogged user' do
        controller.send(:set_identity)
        expect(controller.identity).to be_visitor
      end
    end

    context 'when current game is set' do
      before { allow(controller).to receive(:current_game) { game } }

      it 'detects a game master' do
        create(:character, user: user, game: game, character_type: 2)
        controller.send(:set_identity)
        expect(controller.identity).to be_game_master
      end

      it 'detects a player' do
        create(:character, user: user, game: game)
        controller.send(:set_identity)
        expect(controller.identity).to be_player
      end

      it 'detects a visitor' do
        controller.send(:set_identity)
        expect(controller.identity).to be_visitor
      end
    end
  end

  describe '#current_game' do
    let(:game) { create(:game, character: character) }

    it 'returns the current game' do
      allow(controller).to receive(:params) { { game: game.slug } }
      controller.send(:load_game)
      expect(controller.current_game).to eq(game)
    end
  end
end
