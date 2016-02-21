# frozen_string_literal: true

require 'rails_helper'

describe ProfileController, type: :controller do
  describe '#update' do
    let(:user) { create(:user) }

    it 'prevents unlogged user to edit profile' do
      patch :update, id: user.id, name: user.name, password: '123', 'password-confirmation' => '123'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
      expect(json['message']).to eq('Não foi possível salvar seu perfil. Verifique se a nova senha possui 8 caracteres')
    end

    it 'prevents logged user to change his password providing wrong credentials' do
      allow(controller).to receive(:current_user) { user }
      patch :update, id: user.id, name: user.name, password: '123', 'password-confirmation' => '123'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
      expect(json['message']).to eq('Senha atual incorreta')
    end

    it 'prevents logged user to change his password with wrong password confirmation' do
      allow(controller).to receive(:current_user) { user }
      patch :update, id: user.id, name: user.name, current_password: user.password, password: 'abc', 'password-confirmation' => '123'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
      expect(json['message']).to eq('A nova senha e a confirmação não conferem')
    end

    it 'prevents a user to edit other user profile' do
      allow(controller).to receive(:current_user) { user }
      patch :update, id: 2, name: user.name, password: '123', 'password-confirmation' => '123'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
      expect(json['message']).to eq('Você não pode executar esta ação')
    end
  end
end
