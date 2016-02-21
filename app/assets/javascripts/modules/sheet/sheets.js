define('sheet', [], function() {
  var AttributeTooltip = require('attribute-tooltip');

  function Sheet() {
    new AttributeTooltip('.smart-description');
  };

  var fn = Sheet.prototype;

  return Sheet;
});
