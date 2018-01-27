define('game', ['characters'], function(Characters) {
  function Game(element) {
    this.container = $(element);
    this.characters = new Characters();

    this._loadSystem();
  };

  var fn = Game.prototype;

  fn._loadSystem = function() {
    var url = this.container.val(),
        self = this;

    $.getJSON(url).done(function(system) {
      self.system = system;
    });
  };

  return Game;
});
