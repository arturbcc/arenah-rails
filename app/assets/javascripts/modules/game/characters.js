var Characters = function() {
  this.fullList = [];
  this.pcs = [];
};

var fn = Characters.prototype;

fn.load = function(callback) {
  var url = $('[data-characters-list]').data('characters-list'),
      self = this;

  //$.get("/" + gameRoom + "/personagens/listas").done(function (data) {
  $.getJSON(url).done(function(data) {
    self._loadCharacters(data, callback);
  });
};

fn._loadCharacters = function(data, callback) {
  this.fullList = data.list;
  var self = this;

  $.each(data.pcs, function(index, character) {
    self.pcs.push({
      'id': character.id,
      'text': character.name,
      'avatar': character.avatar
    });
  })

  // if (role == "GameMasterLogged") {
  //   Characters.changeAuthor($("#authors-panel"), 600);
  // }

  if (typeof callback === 'function') {
    callback.call(this);
  }
};
