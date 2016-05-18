// This component answers to an interface. It must respond to `selectionCallback`
//
// * selectionCallback: the method that will be triggered when an attribute is
//   selected in the character sheet;
//
define('compose-post-attribute-selection', ['rules-panel'], function(RulesPanel) {
  function ComposePostAttributeSelection(game) {
    this.rulesPanel = new RulesPanel(game);
    this.game = game;

    $.proxyAll(this, 'selectionCallback');
  };

  var fn = ComposePostAttributeSelection.prototype;

  fn.selectionCallback = function(attribute) {
    if ($('.character-attribute-line').length === 5) {
      NotyMessage.show('Você já escolheu o máximo de atributos possíveis. Remova um ou limpe o painel do sistema de RPG para continuar.', 5000);
    } else {
      var data = this._attributeData(attribute);

      this.rulesPanel.addAttribute(data);
      this._closeAllModals();
    }
  };

  fn._closeAllModals = function() {
    $('.modal').modal('hide');
  };

  fn._attributeData = function(attribute) {
    var id = parseInt($('#sheet').data('character-id')),
        character = this.game.characters.where({ id: id }),
        groupName = attribute.parents('[data-group-name]').data('group-name'),
        attributeName = attribute.data('attribute-name'),
        points = attribute.data('points') || 0,
        value = attribute.data('value') || 0,
        data = {
          "id": id,
          "avatar": character.avatar,
          "name": character.name,
          "groupName": groupName,
          "attributeName": attributeName,
          "points": points,
          "value": value
        };

    return data;
  };

  return ComposePostAttributeSelection;
});
