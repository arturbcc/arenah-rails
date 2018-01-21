# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::SubscriptionController, type: :controller do
  context 'messages' do
    let(:user) { create(:user) }
    let(:character) { create(:character, user: user) }
    let!(:game) { create(:game, character: character) }
    let!(:first_master) { create(:character, :game_master, game: game, user: user) }
    let!(:second_master) { create(:character, :game_master, game: game, user: user) }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe '#create' do
      xit 'sends a message to all game masters' do
        expect { post :create, params: { game: game, format: 'json' } }.to change { Message.all.count }.by 2
        # expect(Message.last.from).to eq(Message::FROM_ARENAH)
        expect(Message.last.body).to eq("Você possui uma [b]nova inscrição[/b] na sala #{game.name}. Para gerenciar as inscrições, acesse [url=javascript:;]o painel[/url].")
      end
    end

    describe '#destroy' do
      xit 'sends a message to all game masters' do
        expect { delete :destroy, params: { game: game, format: 'json' } }.to change { Message.all.count }.by 2
        # expect(Message.last.from).to eq(Message::FROM_ARENAH)
        expect(Message.last.body).to eq("#{user.name} deixou a sala #{game.name}. Para gerenciar as inscrições, acesse [url=javascript:;]o painel[/url].")
      end
    end
  end
end
