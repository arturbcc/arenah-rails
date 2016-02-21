define('sheet', [], function() {
  var AttributeTooltip = require('attribute-tooltip'),
      Instructions = require('instructions');

  function Sheet() {
    this._tooltips();
    this._instructions();
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

  return Sheet;
});
