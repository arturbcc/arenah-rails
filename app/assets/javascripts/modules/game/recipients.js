var Recipients = function(container) {
  $.proxyAll(this, 'parseIds', 'onSelect');

  this.container = $(container);
  this.ids = this.parseIds($('[data-recipients]').data('recipients').split(', '));
};

var fn = Recipients.prototype;

fn.parseIds = function(ids) {
  if (!ids || ids.length == 0) {
    return [];
  }

  var list = [];
  $.each(ids, function(index, id) {
    list.push(parseInt(id));
  });

  return list;
}

fn.onSelect = function(callback) {
  //this.container.select2('val', this.ids);
  this.container.val(this.ids).trigger('change');

  if (typeof callback === 'function') {
    $.each(this.ids, function(index, id) {
      callback.call(id);
    });
  }
};
