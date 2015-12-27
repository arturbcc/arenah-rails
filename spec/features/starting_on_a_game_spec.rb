require 'rails_helper'

feature 'Subscribe to a game' do
  scenario 'navigate to a game and Subscribe' do
    crossover = create(:game, name: 'Crossover')

    visit root_path

    expect(page).to have_css("[data-game] h3", text: crossover.name)

    find('[data-game]', match: :first).click

    expect(page.current_path).to eq game_home_path(crossover)
  end
end
