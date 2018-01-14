define('attributes-list', [], function() {
  // The `groupMethod` are an instance of a class used to group attributes in
  // the selects with the lists of new items to be added in an attributes group (
  // like Perícias or Aprimoramentos, for example).
  //
  // Each one is specialized in a specific type of grouping.
  function AttributesList(groupMethod, items = []) {
    this.groupMethod = groupMethod;
    this.unclassified = [];

    var self = this;
    $.each(items, function() { self.add(this); });
  };

  var fn = AttributesList.prototype;

  fn.add = function(item) {
    var attribute = this._getAttribute(item);

    if (this.groupMethod.accept(item)) {
      this.groupMethod.add(attribute, item);
    } else {
      this._addToUnclassifiedList(attribute);
    }
  };

  fn._getAttribute = function(item) {
    var attribute = '';

    if (this.groupMethod.buildAttribute && typeof this.groupMethod.buildAttribute === 'function') {
      // This callback allows groupers to build their own options for the select.
      attribute = this.groupMethod.buildAttribute(item);
    } else {
      // If no callback is provided, the attributes-list will use the default
      // option attribute, which is below in this file and looks like this:
      //
      // <option value="Herbalismo_0">Herbalismo</option>
      attribute = this._buildAttribute(item);
    }

    return attribute;
  };

  fn.toString = function() {
    var keys = Object.keys(this.groupMethod.data),
        list = this.unclassified,
        self = this;

    $.each(keys, function(_, key) {
      list += "<optgroup label='" + self.groupMethod.data[key].label + "'>" + self.groupMethod.data[key].list + "</optgroup>";
    });

    return list;
  };

  fn._addToUnclassifiedList = function(attribute) {
    this.unclassified.push(attribute);
  };

  fn._buildAttribute = function(item) {
    var value = item.cost || 0,
        text = value ? item.name + ' ' + value : item.name,
        option = $('<option>');

    option.attr({
      'data-name': item.name,
      'data-value': value,
      'data-abbreviation': item.abbreviation,
      'data-base-attribute-group': item.base_attribute_group,
      'data-base-attribute-name': item.base_attribute_name,
    }).text(text);

    return option.get(0).outerHTML;
  };

  return AttributesList;
});
