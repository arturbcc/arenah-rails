page.at('posts#index', function() {
  var topic = $("#topic-slug").val();
  new Post(topic);

  new OnlineUsers();
  new Tooltip();
  new PlayersList();
});

page.at('posts#new', function() {
  var recipients = new Recipients('#recipients');
  var characters = new Characters();
  var composePost = new ComposePost(recipients, characters);

  composePost.autoComplete(627);

  new Editor();
});
