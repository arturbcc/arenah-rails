define('game-system', [], function() {
  function GameSystem() {
    this.system = window.game.system;
  };

  var fn = GameSystem.prototype;

  fn.unusedAttributesList = function(groupName, usedAttributes) {
    var attributes = this.listOfAttributes(groupName);
    return $.grep(attributes, function(attribute) {
      return usedAttributes.indexOf(attribute.name) < 0;
    });
  };

  fn.listOfAttributes = function(groupName) {
    var currentGroup = this._findGroup(groupName);

    return currentGroup.list;
  };

  fn.ListOfcharacterAttributes = function(groupName) {
    var currentGroup = this._findGroup(groupName);

    return currentGroup.character_attributes;
  };

  fn.getAttribute = function(groupName, attributeName) {
    if (groupName && attributeName) {
      var attributes = this.ListOfcharacterAttributes(groupName);

      if (!attributes || attributes.length == 0) {
        attributes = this.listOfAttributes(groupName);
      }

      attributes = attributes || [];
      return $.grep(attributes, function(attribute) {
        return attribute.name == attributeName;
      })[0];
    }
  };

  fn._findGroup = function(groupName) {
    var groups = this.system.sheet.attributes_groups;

    return currentGroup = $.grep(groups, function(group) {
      return group.name === groupName;
    })[0];
  };

  return GameSystem;
});
