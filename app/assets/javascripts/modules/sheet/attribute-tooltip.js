//
//
//
define('attribute-tooltip', [], function() {
  function AttributeTooltip(containers) {
    var containers = $(containers),
        self = this;

    containers.each(function() {
      self._applyTooltipTo($(this));
    });
  };

  var fn = AttributeTooltip.prototype;

  fn._applyTooltipTo = function(element) {
    var row = element.parent().parent(),
        columns = row.parents('[data-columns]').data('columns');

    element.qtip({
      style: {
        classes: 'qtip-bootstrap qtip-bootstrap-' + columns + '-columns'
      },
      content: {
        text: function (event, api) {
          return row.find('.hidden').html();
        }
      },
      position: {
        my: 'top left',
        at: 'bottom left'
      }
    });
  };

  return AttributeTooltip;
});
