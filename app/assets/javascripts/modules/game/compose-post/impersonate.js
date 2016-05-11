define('impersonate', [], function() {
  function Impersonate() {
    this.trigger = $('#compose-post .master img.toggle-panel').parent();
    this.npcContainer = $('#authors-panel');
    this.npc = $('#compose-post .impersonate');
    this.closeButton = $('#compose-post .close');
    this.timer = 600;

    this._bindEvents();
  };

  var fn = Impersonate.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_changeAuthor', '_togglePanel', '_closePanel');

    this.trigger.on('click', this._togglePanel);
    this.npc.on('click', this._changeAuthor);
    this.closeButton.on('click', this._closePanel);
  };

  fn._togglePanel = function() {
    if (!this.npcContainer.is(':visible')) {
      this._openPanel();
    } else {
      this._closePanel();
    }
  };

  fn._changeAuthor = function(event) {
    var npc = $(event.target);

    $('#post_character_id').val(npc.parent().data('id'));
    $('.image-with-caret img').attr('src', npc.attr('src'));
    this._closePanel();
  };

  fn._openPanel = function() {
    var self = this;
    this.npcContainer.show().animate({ height: '510px' }, this.timer, function() {
      self._caretUp();
    });
  };

  fn._closePanel = function() {
    var self = this;
    this.npcContainer.animate({ height: "0" }, this.timer, function () {
      self.npcContainer.hide();
      self._caretDown();
    });
  };

  fn._caretUp = function() {
    $('.caret').addClass('caret-reversed');
  };

  fn._caretDown = function() {
    $('.caret').removeClass('caret-reversed');
  };

  return Impersonate;
});
