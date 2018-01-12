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
    var groups = this.system.sheet.attributes_groups,
        currentGroup = $.grep(groups, function(group) {
          return group.name === groupName;
        })[0];

    return currentGroup.list;
  };

  return GameSystem;
});
