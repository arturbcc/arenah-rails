page.at('game/subscription#show', function() {
  var Subscription = require('subscription');
  new Subscription('.game-subscription');
});

page.at('game/topics#index', function() {
  var Topics = require('topics');
  new Topics('.game-topics');
});
