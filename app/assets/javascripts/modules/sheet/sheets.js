define('sheet', [], function() {
  var AttributeTooltip = require('attribute-tooltip'),
      Instructions = require('instructions'),
      HighlightAttributes = require('highlight-attributes');

  function Sheet() {
    this._tooltips();
    this._instructions();
    this._highlightAttributes();
  };

  var fn = Sheet.prototype;

  fn._tooltips = function() {
    $('.smart-description').each(function() {
      new AttributeTooltip($(this));
    });
  };

  fn._instructions = function() {
    $('.attributes-group-instructions').each(function() {
      new Instructions($(this));
    });
  };

  fn._highlightAttributes = function() {
    new HighlightAttributes();
  };

  return Sheet;
});
