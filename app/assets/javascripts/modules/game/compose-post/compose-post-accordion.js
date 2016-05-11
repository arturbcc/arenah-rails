define('compose-post-accordion', [], function() {
  function ComposePostAccordion(container) {
    this.panels = $(container || '#accordion');
    this.dicePanel = $('#collapseThree');

    this._accordionInitialState();
  };

  var fn = ComposePostAccordion.prototype;

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
    this.openGroupPanel();
  };

  fn.showOnOthers = function(id) {
    this._findGroupCharacter(id).hide();
    this._findOtherCharacter(id).show();
    this.openOtherCharactersPanel();
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

  fn._accordionInitialState = function() {
    var recipients = $('[data-recipients]').data('recipients');
    if (recipients !== '') {
      this.openGroupPanel();
    } else {
      this.openOtherCharactersPanel();
    }
  }

  return ComposePostAccordion;
});
