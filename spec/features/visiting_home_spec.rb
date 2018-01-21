# frozen_string_literal: true

require 'rails_helper'

feature 'Visiting home' do
  scenario 'load games on home page' do
    user = create(:user)
    character = create(:character, user: user)
    game1 = create(:game, character: character)
    game2 = create(:game, character: character, name: 'Crossover')

    visit root_path

    expect(page).to have_css('[data-game]')
    expect(page).to have_css('[data-game] h3', text: game1.name)
    expect(page).to have_css('[data-game] h3', text: game2.name)
  end
end
