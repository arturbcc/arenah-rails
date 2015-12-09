page.at('posts#index', function() {
  var topic = $("#topic-slug").val();
  new Post(topic);

  new OnlineUsers();
  new Tooltip();
  new PlayersList();
});
