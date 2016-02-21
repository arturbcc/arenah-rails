// Highlight Attributes
//
// Display the dependencies among attributes on the sheet.
//
// If the mouse hovers over an attribute, all attributes that are based on it will
// be highlighted. Likewise, if the attribute is based in another one, the base
// attribute will be highlight as well.
//
// The attributes will return to normal as soon as the mouse leaves the element.
define('highlight-attributes', [], function() {
  function HighlightAttributes() {
    this._bindEvents();
  };

  var fn = HighlightAttributes.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_highlight', '_turnOff');

    var basedElements = $('.attributes-with-base tr'),
        nameValueElements = $('.name-value-attributes tr');

    basedElements
      .on('mouseenter', this._highlight)
      .on('mouseleave', this._turnOff);

    nameValueElements
      .on('mouseenter', this._highlight)
      .on('mouseleave', this._turnOff);
  };

  fn._highlight = function(e) {
    var element = $(e.currentTarget),
        searchMethod = this._searchMethodFor(element);

    element.addClass('success')
    searchMethod(element, function(attribute) {
      attribute.addClass('warning');
    });
  };

  fn._turnOff = function(e) {
    var element = $(e.currentTarget),
        searchMethod = this._searchMethodFor(element);

    element.removeClass('success')
    searchMethod(element, function(attribute) {
      attribute.removeClass('warning');
    });
  };

  fn._searchMethodFor = function(attribute) {
    return attribute.parents('table').hasClass('attributes-with-base') ?
      this._findBaseAttribute :
      this._findBasedAttributes;
  };

  fn._findBaseAttribute = function(attribute, callback) {
    var baseAttributeGroup = attribute.data('base-attribute-group'),
        baseAttributeName = attribute.data('base-attribute-name');

    if (baseAttributeGroup && baseAttributeName) {
      var group = $('div[data-group-name=' + baseAttributeGroup + ']');
      var baseAttribute = $("tr[data-attribute-name='" + baseAttributeName + "']", group);

      if (baseAttribute.length > 0 && typeof(callback) == "function") {
        callback(baseAttribute);
      }
    }
  };

  fn._findBasedAttributes = function(attribute, callback) {
    var baseAttributeGroup = attribute.closest('div').data('group-name');
    var baseAttributeName = attribute.data('attribute-name');

    var basedAttributes = $("tr[data-base-attribute-group='" + baseAttributeGroup + "'][data-base-attribute-name='" + baseAttributeName + "']");

    if (basedAttributes.length > 0 && typeof(callback) == "function") {
      callback(basedAttributes);
    }
  };

  return HighlightAttributes;
});
