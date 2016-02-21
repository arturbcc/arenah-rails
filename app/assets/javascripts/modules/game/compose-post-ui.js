define('compose-post-ui', [], function() {
  function ComposePostUI(container) {
    this.panels = $(container || '#accordion');
    this.dicePanel = $('#collapseThree');
  };

  var fn = ComposePostUI.prototype;

  fn.openGroupPanel = function() {
    this.panels.find('a[data-toggle=collapse]').eq(0).trigger('click');
  };

  fn.openOtherCharactersPanel = function() {
    this.panels.find('a[data-toggle=collapse]').eq(1).trigger('click');
  };

  fn.openDicePanel = function() {
    this.panels.find('a[data-toggle=collapse]').eq(2).trigger('click');
  };

  fn.closeAllPanels = function() {
    this.panels.find('.in').removeClass('in');
  };

  fn.showOnGroup = function(id) {
    this._findGroupCharacter(id).show();
    this._findOtherCharacter(id).hide();
  };

  fn.showOnOthers = function(id) {
    this._findGroupCharacter(id).hide();
    this._findOtherCharacter(id).show();
  };

  fn.isInDicePanel = function() {
    return this.dicePanel.hasClass('in');
  };

  fn._findGroupCharacter = function(id) {
    return $('.group-character[data-id=' + id + ']');
  };

  fn._findOtherCharacter = function(id) {
    return $('.other-character[data-id=' + id + ']');
  };

  return ComposePostUI;
});
