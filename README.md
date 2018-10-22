Arenah is a platform to play RPG online. Its main purpose is to allow people to play asynchronously, in a forum, but the new version will have a real-time chat where people can play using all the tools available in the forum.

It was born a decade ago and had more than 1000 users. This project is a new version, to replace the old (and dead) forum (and it is also where I try some new things with Ruby on Rails, we could say it is my personal lab).

Arenah is the grandchild of Tsuki, the first version of the forum.


# Initial structure

run the following commands:

`rake db:drop db:create db:migrate db:seed`
`rake initialize:assets`

# Coverage

To run the tests with a coverages report, run:

`COVERAGE=true rspec`

# Dependencies

* brew install imagemagick


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
