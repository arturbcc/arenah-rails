require 'rails_helper'

describe Game::BaseController, type: :controller do
  describe '#set_identity' do
    let(:user) { create(:user) }
    let!(:game) { create(:game) }

    before do
      allow(controller).to receive(:current_user) { user }
    end

    it 'detects unlogged user' do
      controller.send(:set_identity)
      expect(controller.identity).to be_visitor
    end

    it 'detects a game master' do
      allow(controller).to receive(:current_game) { game }
      create(:character, user: user, game: game, character_type: 2)
      controller.send(:set_identity)
      expect(controller.identity).to be_game_master
    end

    it 'detects a player' do
      allow(controller).to receive(:current_game) { game }
      create(:character, user: user, game: game)
      controller.send(:set_identity)
      expect(controller.identity).to be_player
    end

    it 'detects a visitor' do
      allow(controller).to receive(:current_game) { game }
      controller.send(:set_identity)
      expect(controller.identity).to be_visitor
    end
  end

  describe '#current_game' do
    let(:game) { create(:game) }

    it 'returns the current game' do
      allow(controller).to receive(:params) { { game: game.slug } }
      controller.send(:load_game)
      expect(controller.current_game).to eq(game)
    end
  end
end
