define('recipients', [], function() {
  function Recipients(container) {
    this.container = $(container);

    var recipients = $('[data-recipients]').data('recipients');
    if (recipients == '') {
      this.ids = []
    } else {
      var ids = $('[data-recipients]').data('recipients') + '';
      this.ids = this._parseIds(ids.split(', '));
    }

    $.proxyAll(this, 'parseIds', 'onSelect');
  };

  var fn = Recipients.prototype;

  fn.onSelect = function(callback) {
    //this.container.select2('val', this.ids);
    this.container.val(this.ids).trigger('change');

    if (typeof(callback) === 'function') {
      $.each(this.ids, function(index, id) {
        callback.call(id);
      });
    }
  };

  fn._parseIds = function(ids) {
    if (!ids || ids.length == 0) {
      return [];
    }

    var list = [];
    $.each(ids, function(index, id) {
      list.push(parseInt(id));
    });

    return list;
  };

  return Recipients;
});
