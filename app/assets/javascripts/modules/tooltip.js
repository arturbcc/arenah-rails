var Tooltip = function() {
  this.applyTooltip($('[data-tooltip]'));
};

var fn = Tooltip.prototype;

fn.applyTooltip = function(elements) {
  var self = this;

  $.each(elements, function() {
    var el = $(this);
    el.qtip(self.options(el));
  });
};

fn.options = function(el) {
  return {
    style: {
      classes: el.data('classes') || 'qtip-tipsy',
      width: el.data('width')
    },
    position: {
      my: el.data('my') || 'top center',
      at: el.data('at') || 'bottom center'
    }
  };
};
