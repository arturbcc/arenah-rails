define('source-type-list', ['attributes-list', 'game-system', 'transform', 'positive-negative-method', 'based-attribute-method'], function(AttributesList, GameSystem, Transform, PositiveNegativeMethod, BasedAttributeMethod) {
  function SourceTypeList(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this._backupContent = null;

    this._initialize(data);
  };

  var fn = SourceTypeList.prototype;

  fn._initialize = function(data) {
    this._setEditMode(data);

    var select = this._loadNewAttributesList(data);
    this._bindSelectEvent(select);

    this._startDragAndDrop(data);
    this._configureNewItem(data);
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

  fn._loadNewAttributesList = function(data) {
    var gameSystem = new GameSystem(),
        editContainer = data.attributesGroup.find('.editable-list-group'),
        groupMethod = this._groupMethod(editContainer),
        select = editContainer.find('[data-select-new-attribute]'),
        groupName = data.attributesGroup.data('group-name'),
        unusedAttributes = gameSystem.unusedAttributesList(groupName, this._usedAttributes(editContainer)),
        attributesList = new AttributesList(groupMethod, unusedAttributes),
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
    var gameSystem = new GameSystem(),
        data = this.sheetEditor.currentAttributesGroupData(select),
        groupName = data.attributesGroup.data('group-name'),
        self = this;

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

  fn._startDragAndDrop = function(data) {
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

        self._loadNewAttributesList(data);
      }
    });
  };

  fn._configureNewItem = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        select = editContainer.find('select'),
        addButton = editContainer.find('.add-editable-list-item'),
        self = this;

    addButton.off('click').on('click', function() {
      var data = self.sheetEditor.currentAttributesGroupData(this),
          index = select.prop('selectedIndex'),
          parts = select.val().split('_'),
          name = parts[0],
          points = parseInt(parts[1]),
          abbreviation = parts.length > 2 ? parts[2] : '',
          exceededLimit = data.points && data.usedPoints + points > data.points;

      name = self._removeAbbreviation(name, abbreviation);

      if (self.sheetEditor.isMaster) {
        exceededLimit = false;
      }

      if (index > 0) {
        if (!exceededLimit) {
          var template = $('.editable-list-group[data-group-name=' + data.attributesGroup.attr('data-group-name') + ']').find('.template.hidden:first').clone(),
              items = editContainer.find('.name-value-attributes'),
              description = editContainer.find('.editable-current-item-description .qtip-content').html(),
              newItem = self._fillTemplate(data, template, name, abbreviation, points, description);

          items.append(newItem);

          data.usedPoints = data.usedPoints + parseInt(points);
          self.sheetEditor.changeAttributePoints(data);
          self._newItemTooltip(editContainer, template);
          self._newItemMouseOver(template);
          self._startDragAndDrop(data);
          editContainer.find('.editable-current-item-description').html('');
          self._loadNewAttributesList(data);
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

  fn._inputNewItem = function(data, container, points) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        type = editContainer.parent().data('type'),
        self = this;

    if (type === 'based') {
      var span = $('<span>'), link = $('<a>');

      link.attr({
        'data-editable-attribute': 'spinner',
        'data-master-only': false,
        'data-value': points,
        'href': 'javascript:;'
      }).text(points);

      span.append(link);
      container.append(span);

      link.editable({
        toggle: 'manual',
        showbuttons: false,
        onblur: 'ignore',
        mode: 'inline',
        emptytext: '',
      }).on('shown', function(e, editable) {
        var transformer = new Transform(self.sheetEditor);
        transformer.toSpinner(editable);
      }).editable('show');
    } else {
      container.text(points);
    }
  };

  fn._fillTemplate = function(data, template, name, abbreviation, points, description) {
    points = points || 0;
    template.removeClass('template').removeClass('hidden');
    template.attr('data-attribute-name', name);
    template.attr('data-attribute-abbreviation', abbreviation);
    template.attr('data-points', points);
    template.attr('data-state', 'new');
    template.removeClass('prevent-delete');
    template.find('.smart-description').text(name);

    var textRight = template.find('.text-right');

    if (textRight.length > 0) {
      this._inputNewItem(data, textRight, points);
    }

    template.find('.qtip-titlebar').text(name);
    template.find('.qtip-content').html(description);

    return template;
  };

  fn._groupMethod = function(container) {
    return container.parent().data('type') == 'based' ? new BasedAttributeMethod() : new PositiveNegativeMethod();
  };

  return SourceTypeList;
});
