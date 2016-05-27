define('new-content', [], function() {
  function NewContent(container) {
    this.container = $(container);
    this.activeGroup = $('[data-topic-group-id].active');

    var title = 'Novo tópico em <b>' + this.activeGroup.find('[data-group-name]').text() + '</b>';
    this.container.find('h4').html(title);
  };

  var fn = NewContent.prototype;

  fn._validForm = function() {
    var option = this.container.find('[data-new-content-option]:checked').val(),
        titleInput = this.container.find('#title'),
        nameInput = this.container.find('#name'),
        valid = false;

    if (titleInput.length > 0 && $.trim(titleInput.val()) === '') {
      NotyMessage.show('O título é obrigatório', 2000);
    } else if (nameInput.length > 0 && $.trim(nameInput.val()) === '') {
      NotyMessage.show('O nome é obrigatório', 2000);
    } else {
      valid = true;
    }

    return valid;
  };

  fn.save = function() {
    if (this._validForm()) {
      this.container.find('#topic-group-id').val(this.activeGroup.data('topic-group-id'));

      this.container.submit();
    }
  };

  return NewContent;
});
