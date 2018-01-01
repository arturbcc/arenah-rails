# CI Status

[![Build Status](https://circleci.com/gh/arturcp/arenah-rails.svg?style=shield&circle-token=:circle-token)]()

# Initial structure

run the following commands:

`rake db:drop db:create db:migrate db:seed`
`rake initialize:assets`

# Coverage

To run the tests with a coverages report, run:

`COVERAGE=true rspec`


== Resources ==

bbcode: https://github.com/veger/ruby-bbcode
emoji: emojis taken from http://www.emoji-cheat-sheet.com/
inline css: http://templates.mailchimp.com/resources/inline-css/


# Other infos

1. To enable gmail to send emails:

http://stackoverflow.com/questions/25597507/netsmtpauthenticationerror

The error is because two-factor authentication is enabled for your account. All you need to do to use a gmail account with two-factor authentication enabled is generate a new app password to use with your mailer configuration.

A new app password for gmail can be generated here - https://security.google.com/settings/security/apppasswords.

When generating a new password choose Mail for the Select App setting and Other(Custom name) for the Select Device setting.

Once you have the new password update your mailer configuration with the random string that Google generates for you and you should be set.

# Tasks
* [TO DO LIST](./docs/todo.md)
