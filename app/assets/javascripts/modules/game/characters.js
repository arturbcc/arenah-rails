define('characters', [], function() {
  function Characters() {
    this.fullList = [];
    this.pcs = [];
  };

  var fn = Characters.prototype;

  fn.load = function(callback) {
    var url = $('[data-characters-list]').data('characters-list'),
        self = this;

    $.proxyAll(this, '_loadCharacters');

    $.getJSON(url).done(function(data) {
      self._loadCharacters(data, callback);
    });
  };

  fn._loadCharacters = function(data, callback) {
    var self = this;

    this.fullList = data.list;

    $.each(data.pcs, function(index, character) {
      self.pcs.push({
        id: character.id,
        text: character.name,
        avatar: character.avatar
      });
    })

    // if (role == "GameMasterLogged") {
    //   Characters.changeAuthor($("#authors-panel"), 600);
    // }

    if (typeof(callback) === 'function') {
      callback.call(this);
    }
  };

  return Characters;
});
