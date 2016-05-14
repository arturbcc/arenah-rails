// TODO: should I rename the characters.js to charactersController?
define('characters', ['character'], function(Character) {
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

    $.each(data.list, function(_, character) {
      self.fullList.push(new Character(character));
    });

    $.each(data.pcs, function(index, character) {
      self.pcs.push({
        id: character.id,
        text: character.name,
        avatar: character.avatar
      });
    })

    if (typeof(callback) === 'function') {
      callback.call(this);
    }
  };

  fn.where = function(filters) {
    var self = this;

    return $.grep(this.fullList, function(character) {
      return self._match(character, filters);
    })[0];
  };

  fn._match = function(element, filters) {
    var keys = Object.keys(filters),
        matched = true;

    $.each(keys, function(_, key) {
      matched = matched && element[key] === filters[key];
    });

    return matched;
  };

  return Characters;
});
