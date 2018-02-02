define('source-type-list', ['source-type-list-new-item', 'source-type-list-select'], function(SourceTypeListNewItem, SourceTypeListSelect) {
  function SourceTypeList(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this._backupContent = null;
    this._selectController = new SourceTypeListSelect(this.sheetEditor, this);
    this._newAttributeController = new SourceTypeListNewItem(this.sheetEditor, this);

    this._initialize(data);
  };

  var fn = SourceTypeList.prototype;

  fn.transform = function(editable) {
    editable.$element.editable('hide');
  };

  fn._initialize = function(data) {
    this._setEditMode(data);
    this.startDragAndDrop(data);

    this._selectController.initialize(data);
    this._newAttributeController.initialize(data);

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

  fn.onCancel = function(data) {
    this.leaveEditMode(data);
    this._rollback(data);
  };

  fn.leaveEditMode = function(data) {
    data.attributesGroup.find('[data-accept-edit-mode]').show();
    data.attributesGroup.find('.editable-list-group').addClass('hidden');
    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });
  }

  fn.startDragAndDrop = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        garbage = editContainer.find('.editable-drop-item-area'),
        tooltips = editContainer.find('.smart-description'),
        validDraggableItems = '.editable-list-group[data-group-name=' + data.attributesGroup.data('group-name') + "] tr:not('.prevent-delete')",
        self = this;

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
        var points = 0,
            data = self.sheetEditor.currentAttributesGroupData(this);

        var currentInput = ui.draggable.find('input');
        if (currentInput.length > 0) {
          points = parseInt(currentInput.val());
        } else {
          points = parseInt(ui.draggable.data('points') || ui.draggable.data('value'))
        }

        data.usedPoints = data.usedPoints - points;
        self.sheetEditor.changeAttributePoints(data);
        ui.draggable.remove();
        self.sheetEditor.garbageItems.push(ui.draggable.data('attribute-name'));
        self.loadNewAttributesList(data);
      }
    });
  };

  fn.loadNewAttributesList = function(data) {
    this._selectController.loadNewAttributesList(data);
  };

  // Activate QTip on an element. It will delegate this function to the
  // `SourceTypeListNewItem` component.
  //
  // It is useful when we add a new attribute from a list and click `ok`. The
  // new attribute must appear in the list of items, and it must have the
  // tooltip with the attribute's description. For more information, check the
  // method `_includeAddedAttributes` in the sheet-editor.js component.
  //
  // - container: element inside a sheet page, form where we can go up in the
  //   DOM to find out how many coluns the tooltip should take.
  //
  // - template: element with the .smart-description class. This element will
  //   have the tooltip.
  fn.activateTooltip = function(container, template) {
    this._newAttributeController.newItemTooltip(container, template);
  };

  return SourceTypeList;
});
