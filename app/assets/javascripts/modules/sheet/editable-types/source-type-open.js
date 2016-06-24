define('source-type-open', [], function() {
  function SourceTypeOpen(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this._backupContent = null;

    this._initialize(data);
  };

  var fn = SourceTypeOpen.prototype;

  fn._initialize = function(data) {
    this._setEditMode(data);
    // this.loadSources(data);
    this._startDragAndDrop(data);
    this._backup(data);
  };

  fn._backup = function(data) {
    this._backupContent = data.attributesGroup.find('.editable-list-group').html();
  };

  fn._rollback = function(data) {
    data.attributesGroup.find('.editable-list-group').html(this._backupContent);
  };

  fn._setEditMode = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group');
    editContainer.addClass('edit-mode').removeClass('hidden');
    data.attributesGroup.find('[data-accept-edit-mode]').hide();
  };

  fn._onCancel = function(data) {
    data.attributesGroup.find('[data-accept-edit-mode]').show();
    data.attributesGroup.find('.editable-list-group').addClass('hidden');
    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });
    this._rollback(data);
  };

  fn._transform = function(editable) {
    editable.$element.editable('hide');
  };

  // fn._loadSources = function(data) {
  //   var self = this,
  //       editContainer = data.attributesGroup.find('.editable-list-group'),
  //       select = editContainer.find('select'),
  //       gameSlug = $('#game-room').val(),
  //       groupName = data.attributesGroup.data('group-name');
  //
  //   self._newItem(data);
  // };

  fn._startDragAndDrop = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group');
        garbage = editContainer.find('.editable-drop-item-area');
        tooltips = editContainer.find('.smart-description');
        validDraggableItems = '.editable-list-group[data-group-name=' + data.attributesGroup.data('group-name') + "] tr:not('.prevent-delete')";

    if (!this.sheetEditor.isMaster && !this.sheetEditor.freeMode) {
      $(validDraggableItems).not('[data-state=new]').addClass('prevent-delete');
    }

    editContainer.find('tr[data-attribute-name]').draggable({
      revert: 'invalid',
      start: function(event, ui) {
        ui.helper.css('z-index', 50);
        tooltips.qtip('hide').qtip('disable');
      },
      stop: function(event, ui) {
        ui.helper.css('z-index', 1);
        tooltips.qtip('enable');
      }
    });

    garbage.droppable({
      accept: validDraggableItems,
      hoverClass: 'ui-state-hover',
      drop: function(event, ui) {
        var points = parseInt(ui.draggable.data('points'));
        data.usedPoints = data.usedPoints - points;
        this.sheetEditor._changeAttributePoins(data);
        ui.draggable.remove();
      }
    });
  };

  fn._newItem = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        input = editContainer.find('input.editable-list-input'),
        addButton = editContainer.find('.add-editable-list-item'),
        self = this;

    addButton.unbind().click(function() {
      var name = input.val(),
          template = $('.editable-list-group[data-group-name=' + data.attributesGroup.data('group-name') + ']').find('.template.hidden:first').clone(),
          items = editContainer.find('.name-value-attributes');

      items.append(self._fillTemplate(template, name));
      self._newItemMouseOver(template);
      self._startDragAndDrop(data);
      editContainer.find('.editable-current-item-description').html('');
      input.val('');
    });
  };

  fn._newItemMouseOver = function(template) {
    $(template).mouseenter(function() {
      $(this).addClass('success');
    }).mouseleave(function () {
      $(this).removeClass('success');
    });
  };

  fn._fillTemplate = function(template, name) {
    template.removeClass('template').removeClass('hidden');
    template.attr('data-attribute-name', name);
    template.find('.smart-description').text(name);
    template.attr('data-state', 'new');
    template.removeClass('prevent-delete');

    return template;
  };

  return SourceTypeOpen;
});
