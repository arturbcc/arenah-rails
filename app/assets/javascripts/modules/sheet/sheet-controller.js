define('sheet-controller', ['compose-post-attribute-selection'], function(ComposePostAttributeSelection) {
  function SheetController() {
    this.game = window.game;

    this._bindEvents();
  };

  var fn = SheetController.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_composePostSelectorCallback');
  };

  fn.attributeSelectorCallback = function() {
    var callback;

    if (this._isComposePost()) {
      var selector = new ComposePostAttributeSelection(this.game);
      callback = selector.selectionCallback;
    }

    return callback;
  };

  fn._isComposePost = function() {
    return $('#compose-post').length > 0;
  };

  return SheetController;
});
