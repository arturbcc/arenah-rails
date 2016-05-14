page.at('game/posts#index', function() {
  var OnlineUsers = require('online-users'),
      PlayersList = require('players-list'),
      Tooltip = require('tooltip'),
      Post = require('post');

  new OnlineUsers('[online-users]');
  new PlayersList({ container: '#sidePanel' });
  new Tooltip('[data-tooltip]');

  var topic = $("#topic-slug").val();
  new Post(topic);
});

page.at('game/posts#new game/posts#edit', function() {
  var Recipients = require('recipients'),
      ComposePost = require('compose-post'),
      Editor = require('editor'),
      ComposePostDice = require('compose-post-dice'),
      Game = require('game');

  var recipients = new Recipients('input[type=text]#post_recipients'),
      game = new Game('#game_system_url'),
      composePost = new ComposePost(game, recipients),
      composePostDice = new ComposePostDice();

  new Editor();
});
