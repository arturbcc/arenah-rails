# frozen_string_literal: true

module SignInHelper
  def sign_in(user, visit_login_page = false)
    visit new_user_session_path if visit_login_page

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Entrar'
  end
end

RSpec.configure do |config|
  config.include SignInHelper, type: :feature
end
