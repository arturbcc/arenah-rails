define('groups-controller', [], function() {
  function GroupsController(container) {
    this.container = $(container);
    this.adminTools = $('.admin-tools-for-groups');

    this._bindEvents();
  };

  var fn = GroupsController.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_delete', '_updateButtonCounter');

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
        name = element.parents('[data-topic-group-id]').find('[data-group-name]').text(),
        self = this,
        message = 'Tem certeza que deseja excluir a categoria <b>' + name + '</b>? ' +
          'Todos os tópicos e posts dela serão apagados e esta operação não poderá ser desfeita.';

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
              self._updateButtonCounter();

              var activeGroup = $('[data-topic-group-id].active');
              if (activeGroup.length == 0) {
                $('[data-topic-group-id]:first').trigger('click');
              }
            }
          }
        });
      }
    });
  };

  fn._updateButtonCounter = function() {
    var label = $('.btn-gold span'),
        text = $.trim(label.text()),
        index = text.search(/\(\d\/\d\)/i),
        match = text.slice(index),
        current = parseInt(match[1]),
        newText = this._replaceAt(text, (current - 1) + '', index + 1);

    label.text(newText);
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

  fn._replaceAt = function(text, character, index) {
    return text.substr(0, index) + character + text.substr(index + character.length);
  }

  return GroupsController;
});
