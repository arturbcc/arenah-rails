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
  var Characters = require('characters'),
      Recipients = require('recipients'),
      ComposePost = require('compose-post'),
      Editor = require('editor');

  var recipients = new Recipients('input[type=text]#post_recipients'),
      characters = new Characters(),
      composePost = new ComposePost(recipients, characters);

  new Editor();
});
