define('topics-controller', [], function() {
  function TopicsController(container) {
    this.container = $(container);
    this.adminTools = $('.admin-tools-for-topic');

    this._bindEvents();
  };

  var fn = TopicsController.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_delete');

    this._allowTopicSorting();

    this.adminTools.on('click', '.fa-remove', this._delete);
  };

  fn._allowTopicSorting = function() {
    var self = this;

    $('.topic-info').sortable({
      start: function(event, ui) {
        $(ui.helper).addClass('notransition');
        $(this).addClass('sorting');
      },
      stop: function(event, ui) {
        $(ui.helper).removeClass('notransition');
        $(this).removeClass('sorting');
        self._sort();
      },
      tolerance: 'pointer',
    });
  };

  fn._delete = function(e) {
    var element = $(e.target),
        name = element.parents('.topic-line').find('.title').text(),
        url = element.data('delete-url'),
        container = this.container,
        message = 'Tem certeza que deseja excluir o tópico <b>' + name + '</b>? ' +
          'Todos os posts do tópico serão apagados e esta operação não poderá ser desfeita.';

    bootbox.confirm(message, function(result) {
      if (result) {
        $.ajax({
          url: url,
          type: 'DELETE',
          success: function (data) {
            if (data.status !== 200) {
              NotyMessage.show('Não foi possível excluir o tópico');
            } else {
              var topicLine = container.find('[data-topic-id="' + element.data('topic-id') + '"]')
              element.parent().remove();
              topicLine.remove();
            }
          }
        });
      }
    });
  };

  fn._sort = function() {
    var changes = {},
        url = $('.topic-info').data('topic-sorting-url');

    $.each($('.subgroup-visible .fm-nav'), function (index) {
      changes[$(this).data('topic-id')] = index + 1;
    });

    $.ajax({
      url: url,
      traditional: true,
      data: {
        changes: JSON.stringify(changes)
      },
      type: 'POST',
      success: function (data) {
        if (data.status !== 200) {
          NotyMessage.show('Não foi possível reordenar os tópicos');
        } else {
          NotyMessage.show('Tópicos ordenados com sucesso!', 3000, 'success');
        }
      }
    });
  };

  return TopicsController;
});
