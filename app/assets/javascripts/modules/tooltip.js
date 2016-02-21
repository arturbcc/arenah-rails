define('tooltip', [], function() {
  function Tooltip(container) {
    this.container = $(container);

    this._bindEvents();
  };

  var fn = Tooltip.prototype;

  fn._bindEvents = function() {
    var self = this;

    this.container.each(function() {
      var el = $(this);
      el.qtip(self._options(el));
    });
  };

  fn._options = function(el) {
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

  return Tooltip;
});
