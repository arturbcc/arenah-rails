define('source-type-list', ['attributes-list', 'game-system'], function(AttributesList, GameSystem) {
  function SourceTypeList(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this._backupContent = null;
    this.data = data;

    this._initialize(data);
  };

  var fn = SourceTypeList.prototype;

  fn._initialize = function() {
    this._setEditMode();

    var select = this._loadNewItemsList();
    this._bindSelectEvent(select);

    this._startDragAndDrop();
    this._configureNewItem();
    this._backup();
  };

  fn._backup = function() {
    this._backupContent = this.data.attributesGroup.find('.editable-list-group').html();
  };

  fn._rollback = function(data) {
    data.attributesGroup.find('.editable-list-group').html(this._backupContent);
  };

  fn._setEditMode = function() {
    var editContainer = this.data.attributesGroup.find('.editable-list-group');
    editContainer.addClass('edit-mode').removeClass('hidden');
    this.data.attributesGroup.find('[data-accept-edit-mode]').hide();
  };

  fn.onCancel = function(data) {
    data.attributesGroup.find('[data-accept-edit-mode]').show();
    data.attributesGroup.find('.editable-list-group').addClass('hidden');
    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });

    this._rollback(data);
  };

  fn.transform = function(editable) {
    editable.$element.editable('hide');
  };

  fn._loadNewItemsList = function() {
    var gameSystem = new GameSystem(),
        editContainer = this.data.attributesGroup.find('.editable-list-group'),
        select = editContainer.find('[data-select-new-attribute]'),
        groupName = this.data.attributesGroup.data('group-name'),
        unusedAttributes = gameSystem.unusedAttributesList(groupName, this._usedAttributes(editContainer)),
        attributesList = new AttributesList(unusedAttributes),
        self = this;

    this._removeSelect2Fields();
    select.empty();
    select.append('<option value="0">Selecione...</option>');
    select.append(attributesList.toString());
    select = select.select2({ width: '70%', dropdownParent: $('.modal') });

    return select;
  };

  fn._removeSelect2Fields = function() {
    $('.select2-container').remove();
  };

  fn._bindSelectEvent = function(select) {
    var self = this,
        gameSystem = new GameSystem(),
        groupName = this.data.attributesGroup.data('group-name');

    select.on('change', function() {
      var index = select.prop('selectedIndex'),
          descriptionContainer = $(this).siblings('.editable-current-item-description');

      descriptionContainer.html('');

      if (index > 0) {
        var parts = $(this).val().split('_'),
            name = parts[0],
            points = parts[1],
            abbreviation = parts.length > 2 ? parts[2] : '';

        name = self._removeAbbreviation(name, abbreviation);

        var style = {
          width: '90%',
          margin: '5px auto',
          padding: '5px',
          border: '1px solid #000',
          backgroundColor: '#fff',
          boxShadow: '3px 3px 3px #675D5D'
        };

        var table = $('<table>'),
            tr = $('<tr>'),
            td = $('<td>'),
            qtipTitle = $('<div>'),
            qtipContent = $('<div>');

        qtipTitle.addClass('qtip-titlebar').html(name);
        qtipContent.addClass('qtip-content').html(self._fetchItemDescription(gameSystem.listOfAttributes(groupName), name));
        td.append(qtipTitle).append(qtipContent);
        tr.append(td);
        table.append(tr).css(style);

        descriptionContainer.html(table);
      }
    });
  };

  fn._usedAttributes = function(editContainer) {
    var usedAttributes = [];

    $.each(editContainer.find('[data-attribute-name]'), function() {
      var item = $($(this)[0]).data('attribute-name'),
          text = $.trim(item);

      if (text !== '') {
        usedAttributes.push(text);
      }
    });

    return usedAttributes;
  };

  fn._removeAbbreviation = function(name, abbreviation) {
    var abbreviation = ' (' + (abbreviation == '' ? '0' : abbreviation) + ')';
    return name.replace(abbreviation, '');
  };

  fn._fetchItemDescription = function(list, name) {
    var item = $.grep(list, function (item) { return item.name === name; });
    return item != undefined && item[0].description ? item[0].description : 'Sem descrição';
  };

  fn._startDragAndDrop = function() {
    var editContainer = this.data.attributesGroup.find('.editable-list-group'),
        garbage = editContainer.find('.editable-drop-item-area'),
        tooltips = editContainer.find('.smart-description'),
        validDraggableItems = '.editable-list-group[data-group-name=' + this.data.attributesGroup.data('group-name') + "] tr:not('.prevent-delete')",
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
        var points = parseInt(ui.draggable.data('points') || ui.draggable.data('value'));

        self.data.usedPoints = self.data.usedPoints - points;
        self.sheetEditor.changeAttributePoints(self.data);
        ui.draggable.remove();
      }
    });
  };

  fn._configureNewItem = function() {
    var editContainer = this.data.attributesGroup.find('.editable-list-group'),
        select = editContainer.find('select'),
        addButton = editContainer.find('.add-editable-list-item'),
        self = this;

    addButton.unbind().click(function () {
      var index = select.prop('selectedIndex'),
          // name = select.select2('data').text,
          parts = select.val().split('_'),
          name = parts[0],
          points = parseInt(parts[1]),
          abbreviation = parts.length > 2 ? parts[2] : '',
          exceededLimit = self.data.points && self.data.usedPoints + points > self.data.points;

      name = self._removeAbbreviation(name, abbreviation);

      if (self.sheetEditor.isMaster) {
        exceededLimit = false;
      }

      if (index > 0) {
        if (!exceededLimit) {
          var template = $('.editable-list-group[data-group-name=' + self.data.attributesGroup.attr('data-group-name') + ']').find('.template.hidden:first').clone(),
              items = editContainer.find('.name-value-attributes'),
              description = editContainer.find('.editable-current-item-description .qtip-content').html(),
              newItem = self._fillTemplate(template, name, abbreviation, points, description);

          items.append(newItem);

          self.data.usedPoints = self.data.usedPoints + parseInt(points);
          self.sheetEditor.changeAttributePoints(self.data);
          self._newItemTooltip(editContainer, template);
          self._newItemMouseOver(template);
          self._startDragAndDrop();
          editContainer.find('.editable-current-item-description').html('');
          self._loadNewItemsList();
          select.select2('val', '0');

          if (self.onNewItem && typeof self.onNewItem == "function") {
            self.onNewItem(newItem);
          }
        } else {
          NotyMessage.show('Você não possui pontos para adicionar este atributo', 3000);
        }
      } else {
        NotyMessage.show('Escolha um item na lista antes de adicioná-lo', 3000, 'info');
      }
    });
  };

  fn._newItemTooltip = function(editContainer, template) {
    var columns = editContainer.parents('[data-columns]:first').attr('data-columns'),
        item = template.find('.smart-description');

    $(item).qtip({
      style: {
        classes: 'qtip-bootstrap qtip-bootstrap-' + columns + '-columns'
      },
      content: {
        text: function (event, api) {
          var row = $(item).parent().parent();
          return row.find('.hidden').html();
        }
      },
      position: {
        my: 'top left',
        at: 'bottom left'
      }
    });
  };

  fn._newItemMouseOver = function(template) {
    $(template).mouseenter(function() {
      $(this).addClass('success');
    }).mouseleave(function() {
      $(this).removeClass('success');
    });
  };

  fn._inputNewItem = function(container, points) {
    container.text(points);
  },

  fn._fillTemplate = function(template, name, abbreviation, points, description) {
    template.removeClass('template').removeClass('hidden');
    template.attr('data-attribute-name', name);
    template.attr('data-attribute-abbreviation', abbreviation);
    template.attr('data-points', points);
    template.attr('data-state', 'new');
    template.removeClass('prevent-delete');
    template.find('.smart-description').text(name);

    var textRight = template.find('.text-right');

    if (textRight.length > 0) {
      this._inputNewItem(textRight, points);
    }

    template.find('.qtip-titlebar').text(name);
    template.find('.qtip-content').html(description);

    return template;
  };

  return SourceTypeList;
});
