var Recipients = function(container) {
  this.container = $(container);
  this.ids = this.parseIds($('[data-recipients]').data('recipients').split(', '));
};

var fn = Recipients.prototype;

fn.parseIds = function(ids) {
  if (!this.ids) {
    return [];
  }

  var list = [];
  $.each(this.ids, function(index, id) {
    list.push(parseInt(id));
  });

  return list;
}

fn.onSelect = function(callback) {
  this.container.select2('val', this.ids);

  if (typeof callback === 'function') {
    $.each(this.ids, function(index, id) {
      callback.call(id);
    });
  }
};
