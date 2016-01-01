require 'rails_helper'

describe Game::SubscriptionController, type: :controller do
  context 'messages' do
    let(:user) { create(:user) }
    let!(:game) { create(:game) }
    let!(:first_master) { create(:character, :game_master, game: game, user: user) }
    let!(:second_master) { create(:character, :game_master, game: game, user: user) }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe '#create' do
      it 'sends a message to all game masters' do
        expect { post :create, game: game, format: 'json' }.to change { Message.all.count }.by 2
        expect(Message.last.from).to eq(Message::FROM_ARENAH)
        expect(Message.last.body).to eq("Você possui uma [b]nova inscrição[/b] na sala #{game.name}. Para gerenciar as inscrições, acesse [url=javascript:;]o painel[/url].")
      end
    end

    describe '#destroy' do
      it 'sends a message to all game masters' do
        expect { delete :destroy, game: game, format: 'json' }.to change { Message.all.count }.by 2
        expect(Message.last.from).to eq(Message::FROM_ARENAH)
        expect(Message.last.body).to eq("#{user.name} deixou a sala #{game.name}. Para gerenciar as inscrições, acesse [url=javascript:;]o painel[/url].")
      end
    end
  end
end
