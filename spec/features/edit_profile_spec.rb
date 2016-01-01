require 'rails_helper'

feature 'Edit Profile' do
  let!(:user) { create(:user) }

  scenario 'Open the profile and change user data', js: true do
    sign_in user, true
    visit root_path

    click_link "Olá, #{user.name}"
    wait_for_ajax

    expect(page.body).to have_css('.modal-content')
    expect(page.body).to have_css("input[value='#{user.name}']")

    fill_in 'name', with: 'fake name'

    click_button 'Salvar'
    wait_for_ajax

    expect(find("[data-hello]")).to have_content("OLÁ, FAKE NAME")

    click_link "Olá, fake name"
    wait_for_ajax

    fill_in 'name', with: 'John Doe'
    fill_in 'current-password', with: user.password
    fill_in 'new-password', with: '987654321'
    fill_in 'password-confirmation', with: '987654321'

    click_button 'Salvar'
    wait_for_ajax

    expect(find("[data-hello]")).to have_content("OLÁ, JOHN DOE")
  end
end
