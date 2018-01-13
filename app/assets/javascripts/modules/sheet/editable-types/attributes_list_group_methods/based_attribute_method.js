// The based-attributes method will separate values according to base attributes.
// Each base attribute will become a category in the list, and lists without a
// base will be added to an unclassified list.
define('based-attribute-method', ['game-system'], function(GameSystem) {
  function BasedAttributeMethod() {
    this.data = {};
    this.gameSystem = new GameSystem();
  };

  var fn = BasedAttributeMethod.prototype;

  fn.add = function(attribute, item) {
    var baseAttributeName = item.base_attribute_name;

    if (!this.data[baseAttributeName]) {
      var baseAttribute = this.gameSystem.getAttribute(item.base_attribute_group, baseAttributeName),
          label = '';

      label = baseAttributeName;
      if (baseAttribute) {
        label += ' (' + baseAttribute.abbreviation + ')';
      }
      this.data[baseAttributeName] = { label: label, list: [] };
    }

    this.data[baseAttributeName].list.push(attribute);
  };

  fn.accept = function(item) {
    return item.base_attribute_name;
  };

  return BasedAttributeMethod;
});
