ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => ENV['MAIL_USER_NAME'],
  :password             => ENV['MAIL_USER_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

Rails.application.configure do
  if Rails.env.development?
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  elsif Rails.env.test?
    # Tell Action Mailer not to deliver emails to the real world.
    # The :test delivery method accumulates sent emails in the
    # ActionMailer::Base.deliveries array.
    config.action_mailer.delivery_method = :test
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  end
end
