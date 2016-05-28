page.at(':before', function() {
  var Game = require('game'),
      HeaderMenu = require('header-menu');

  // Load the window.game with the current system in all game pages.
  // the game_system_url is defined on the application.html.erb, inside the
  // views/layout folder:
  //
  // <%= hidden_field :game_system, :url, value: game_system_path(@game) %>
  if ($('#game_system_url').length > 0) {
    window.game = new Game('#game_system_url');
  }

  new HeaderMenu();
});
