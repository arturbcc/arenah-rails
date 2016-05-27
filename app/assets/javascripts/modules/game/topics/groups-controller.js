define('groups-controller', [], function() {
  function GroupsController(container) {
    this.container = $(container);
    this.adminTools = $('.admin-tools-for-groups');

    this._bindEvents();
  };

  var fn = GroupsController.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_delete');

    this._allowGroupSorting();

    this.adminTools.on('click', '.fa-remove', this._delete);
  };

  fn._allowGroupSorting = function() {
    var self = this;

    this.adminTools.sortable({
      start: function(event, ui) {
        $(this).css('border', '1px dashed #eee');
      },
      stop: function(event, ui) {
        $(this).css('border', '0');
        self._sort();
      },
      tolerance: 'pointer',
      axis: 'x'
    });
  };

  fn._delete = function(e) {
    var element = $(e.target),
        url = element.data('delete-url'),
        self = this,
        message = 'Tem certeza que deseja excluir a categoria? ' +
          'Todos os tópicos e posts serão apagados e esta operação não poderá ser desfeita.';

    bootbox.confirm(message, function(result) {
      if (result) {
        $.ajax({
          url: url,
          type: 'DELETE',
          success: function (data) {
            if (data.status !== 200) {
              NotyMessage.show('Não foi possível excluir a categoria');
            } else {
              element.parents('li').remove();
            }
          }
        });
      }
    });
  };

  fn._sort = function() {
    var changes = {},
        url = this.adminTools.data('group-sorting-url');

    $.each(this.adminTools.find('li'), function(index) {
      changes[$(this).data('topic-group-id')] = index + 1;
    });

    $.ajax({
      url: url,
      traditional: true,
      data: {
        changes: JSON.stringify(changes)
      },
      type: 'POST',
      success: function(data) {
        if (data.status !== 200) {
          NotyMessage.show('Não foi possível reordenar as categorias');
        }
      }
    });
  };

  return GroupsController;
});
