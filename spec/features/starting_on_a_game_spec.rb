# frozen_string_literal: true

require 'rails_helper'

feature 'Subscribe to a game' do
  let!(:user) { create(:user) }
  let!(:crossover) { create(:game, name: 'Crossover') }

  scenario 'navigate to a game and Subscribe', js: true do
    visit root_path

    expect(page).to have_css('[data-game] h3', text: crossover.name)

    find('[data-game=crossover]', match: :first).click

    expect(page.current_path).to eq game_home_path(crossover)

    find('[data-header=sign-in]', match: :first).click
    sign_in user

    expect(page.current_path).to eq game_home_path(crossover)
    expect(page.body).to have_css('.user-avatar')

    find('[data-menu=subscription]', match: :first).click

    expect(page.current_path).to eq game_subscription_path(crossover)
    expect(page.body).to have_css('.normal-border')

    node = find('.onoffswitch-inner', match: :first)
    node.trigger('click')
    wait_for_ajax

    expect(page.body).to have_css('.gold-border')

    node = find('.onoffswitch-inner', match: :first)
    node.trigger('click')
    wait_for_ajax

    expect(page.body).not_to have_css('.gold-border')
  end
end
