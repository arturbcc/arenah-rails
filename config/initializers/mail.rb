
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => ENV['MAIL_USER_NAME'],
  :password             => ENV['MAIL_USER_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
