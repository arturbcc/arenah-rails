module SignInHelper
  def sign_in(user)
    visit root_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Login'
  end
end

RSpec.configure do |config|
  config.include SignInHelper, type: :feature
end
