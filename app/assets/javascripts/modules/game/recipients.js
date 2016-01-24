var Recipients = function(container) {
  this.panels = new ComposePostPanels();

  this.container = $(container);
  this.ids = this.parseIds($('[data-recipients]').data('recipients').split(', '));

  this.bindEvents();
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

fn.bindEvents = function() {
  var panels = this.panels;

  this.container.select2('val', this.ids);

  $.each(this.ids, function(index, id) {
    panels.showOnGroup(id);
  });
};
