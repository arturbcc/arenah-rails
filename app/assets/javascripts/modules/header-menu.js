define('header-menu', [], function() {
  function HeaderMenu() {
    this._bindEvents();
  };

  var fn = HeaderMenu.prototype;

  fn._bindEvents = function() {
    this._tooltipForMyCharacters();
  };

  fn._tooltipForMyCharacters = function() {
    var characters = $('#my-characters img');

    if (characters.length > 0) {
      $('#my-characters img').qtip({
        style: {
          classes: 'qtip-bootstrap'
        },
        position: {
          my: 'top center',
          at: 'bottom center'
        }
      });
    }
  };

  return HeaderMenu;
});
