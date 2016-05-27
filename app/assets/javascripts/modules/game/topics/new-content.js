define('new-content', [], function() {
  function NewContent(container) {
    this.container = $(container);
  };

  var fn = NewContent.prototype;

  fn._validForm = function() {
    var option = this.container.find('[data-new-content-option]:checked').val(),
        title = $.trim(this.container.find('#title').val()),
        valid = true;

    if (title === '') {
      valid = false;
      NotyMessage.show('O título é obrigatório', 2000);
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
