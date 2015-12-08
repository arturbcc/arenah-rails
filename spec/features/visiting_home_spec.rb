require 'rails_helper'

feature 'Visiting home' do
  scenario 'load games on the home' do
    game1 = create(:game)
    game2 = create(:game, name: 'Crossover')

    visit root_path

    expect(page).to have_css('[data-game]')
    expect(page).to have_css("[data-game] h3", text: game1.name)
    expect(page).to have_css("[data-game] h3", text: game2.name)
  end
end
