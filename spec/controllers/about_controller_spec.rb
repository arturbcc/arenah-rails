# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  describe '#show' do
    it 'reponds to a get request' do
      get :show

      expect(response.status).to eq(200)
      expect(assigns(:area).current).to eq(:about)
    end
  end
end
