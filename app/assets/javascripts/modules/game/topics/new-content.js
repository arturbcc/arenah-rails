define('new-content', [], function() {
  function NewContent(container) {
    this.container = $(container);

    this._bindEvents();
  };

  var fn = NewContent.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_onChangeRadioButton');

    this.container
      .find('[data-new-content-option]')
      .on('change', this._onChangeRadioButton);
  };

  fn._onChangeRadioButton = function(e) {
    var id = $(e.currentTarget).val(),
        descriptionContainer = this.container.find('#description-container');

    if (id === 'topic') {
      descriptionContainer.removeClass('hidden');
    } else if (id === 'category') {
      descriptionContainer.addClass('hidden');
    }
  };

  fn._validForm = function() {
    var option = this.container.find('[data-new-content-option]:checked').val(),
        title = $.trim(this.container.find('#title').val()),
        description = $.trim(this.container.find('#description').val()),
        valid = false;

    if (option === 'topic' && (title === '' || description === '')) {
      NotyMessage.show('Todos os campos são obrigatórios', 2000);
    } else if (option === 'category' && title === '') {
      NotyMessage.show('O título é obrigatório', 2000);
    } else {
      valid = true;
    }

    return valid;
  };

  fn.save = function() {
    if (this._validForm()) {
      var activeGroup = $('[data-topic-group-id].active');

      this.container.find('#topic-group-id').val(activeGroup.data('topic-group-id'));
      this.container.submit();
    }
  };

  return NewContent;
});
