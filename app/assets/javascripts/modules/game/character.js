define('character', [], function() {
  function Character(data) {
    var keys = Object.keys(data),
        self = this;

    keys.forEach(function(methodName) {
      self[methodName] = data[methodName];
    });
  };

  var fn = Character.prototype;

  fn.attributes_group = function(groupName) {
    groupName = groupName.toLowerCase();

    return $.grep(this.sheet.attributes_groups, function(group) {
      return group.name.toLowerCase() === groupName;
    })[0];
  };

  fn.attribute = function(groupName, attributeName) {
    attributeName = attributeName.toLowerCase();

    var group = this.attributes_group(groupName),
        character_attribute;

    if (group) {
      character_attribute = $.grep(group.character_attributes, function(character_attribute) {
        return character_attribute.name.toLowerCase() == attributeName;
      })[0];
    }

    return character_attribute;
  };

  return Character;
});
