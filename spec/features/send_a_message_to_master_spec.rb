# frozen_string_literal: true

require 'rails_helper'

feature 'Send a message to game master' do
  let!(:user) { create(:user) }
  let!(:game) { create(:game, name: 'Crossover') }

  scenario 'Enter in a game and send a message' do
    visit game_new_contact_path(game)
    expect(page.body).to have_css('.login-section')

    sign_in user
    visit game_new_contact_path(game)

    expect(page.body).to have_css('.game-contact')

    click_button 'Enviar'

    error_message = 'a mensagem é obrigatória'

    expect(page).to have_css('dl dt span', text: "(#{error_message})")

    fill_in 'message_body', with: 'fake message'
    click_button 'Enviar'

    expect(page).not_to have_css('dl dt span', text: "(#{error_message})")
    expect(page.current_path).to eq game_new_contact_path(game)
  end
end
