# frozen_string_literal: true

class ProfileController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def edit
    render partial: 'shared/modal', locals: {
      partial_name: 'edit',
      save_button: true,
      save_method: 'EditUserProfile.save',
      on_load_method: 'EditUserProfile.initialize();'
    }
  end

  def update
    if current_user.id == params[:id].to_i
      password = params[:password]
      current_user.name = params[:name]
      result = { status: 200 }

      if password.present?
        result = change_password
      end

      if result[:status] == 200
        current_user.save!
        sign_in current_user, :bypass => true
      end

      render json: result
    else
      render json: { status: 422, message: 'Você não pode executar esta ação' }
    end
  rescue
    render json: { status: 422, message: 'Não foi possível salvar seu perfil. Verifique se a nova senha possui 8 caracteres' }
  end

  private

  def change_password
    current_password = params[:current_password]
    password = params[:password]
    confirmation = params[:password_confirmation]
    result = { status: 200 }

    if current_user.valid_password?(current_password)
      if password == confirmation
        current_user.password = password
      else
        result = { status: 422, message: 'A nova senha e a confirmação não conferem' }
      end
    else
      result = { status: 422, message: 'Senha atual incorreta' }
    end

    result
  end
end
