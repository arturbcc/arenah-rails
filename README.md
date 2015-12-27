== CI Status

[![Build Status](https://travis-ci.org/arturcp/arenah-rails.svg?branch=master)](https://travis-ci.org/arturcp/arenah-rails)

== Initial structure

run the following commands:

`rake db:drop db:create db:migrate db:seed`
`rake initialize:assets`


== Resources ==

bbcode: https://github.com/veger/ruby-bbcode
emoji: emojis taken from http://www.emoji-cheat-sheet.com/


=== TODO LIST ===

* Video Chat: check the conference.txt file on the root folder

* Carousel - Home (js?)
* Tooltip not working on posts
  >> Change all markup to pass data through data attributes. The Tooltip.js class will handle it.
  >> Check al valid parameters to pass and provide default behavior
* http://colorschemedesigner.com/csd-3.5/#
* minimalist theme
* responsive layout
* single typeface for the whole layout

* Use Devise?
* Use Cancancan? Aparently no
* Use Rolify? https://github.com/RolifyCommunity/rolify Can be!


== Other infos ==

1. To enable gmail to send emails:

http://stackoverflow.com/questions/25597507/netsmtpauthenticationerror

The error is because two-factor authentication is enabled for your account. All you need to do to use a gmail account with two-factor authentication enabled is generate a new app password to use with your mailer configuration.

A new app password for gmail can be generated here - https://security.google.com/settings/security/apppasswords.

When generating a new password choose Mail for the Select App setting and Other(Custom name) for the Select Device setting.

Once you have the new password update your mailer configuration with the random string that Google generates for you and you should be set.
