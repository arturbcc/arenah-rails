// SourceTypeListNewItem deals with new attributes. All logic related to the
// behavior of the attribute group when a new item is added from a list is here.
define('source-type-list-new-item', ['transform', 'game-system'], function(Transform, GameSystem) {
  function SourceTypeListNewItem(sheetEditor, sourceTypeList) {
    this.sheetEditor = sheetEditor;
    this.sourceTypeList = sourceTypeList;
  };

  var fn = SourceTypeListNewItem.prototype;

  fn.initialize = function(data) {
    this._bindEvents(data);
  };

  fn._bindEvents = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        addButton = editContainer.find('.add-editable-list-item');

    addButton.off('click').on('click', $.proxy(this._addAttribute, this));
  };

  fn._addAttribute = function(event) {
    var data = this.sheetEditor.currentAttributesGroupData($(event.currentTarget)),
        editContainer = data.attributesGroup.find('.editable-list-group'),
        select = editContainer.find('select'),
        index = select.prop('selectedIndex'),
        selectedValue = select.find(':selected'),
        points = selectedValue.data('value') || 0,
        exceededLimit = data.points && data.usedPoints + points > data.points;

    if (this.sheetEditor.isMaster) {
      exceededLimit = false;
    }

    if (index > 0) {
      if (!exceededLimit) {
        var groupName = data.attributesGroup.attr('data-group-name'),
            template = $('.editable-list-group[data-group-name=' + groupName + ']').find('.template.hidden:first').clone(),
            items = editContainer.find('.name-value-attributes'),
            description = editContainer.find('.editable-current-item-description .qtip-content').html(),
            newItem = this._fillTemplate(data, template, description, selectedValue);

        items.append(newItem);

        this.sheetEditor.addNewItem(groupName, newItem.data('attribute-name'),
          newItem.data('points'));

        data.usedPoints = data.usedPoints + parseInt(points);
        this.sheetEditor.changeAttributePoints(data);

        this.newItemTooltip(editContainer, template);
        this._newItemMouseOver(template);
        this._clearDescription(editContainer);

        this.sourceTypeList.startDragAndDrop(data);
        this.sourceTypeList.loadNewAttributesList(data);
        select.select2('val', '0');
        data.attributesGroup.find('.empty-group-warning').hide();
      } else {
        NotyMessage.show('Você não possui pontos para adicionar este atributo', 3000);
      }
    } else {
      NotyMessage.show('Escolha um item na lista antes de adicioná-lo', 3000, 'info');
    }
  };

  fn._clearDescription = function(editContainer) {
    editContainer.find('.editable-current-item-description').html('');
  };

  fn.newItemTooltip = function(editContainer, template) {
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

  fn._newItemInput = function(data, container, points) {
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
        emptytext: ''
      }).on('shown', function(e, editable) {
        var transformer = new Transform(self.sheetEditor);
        transformer.toSpinner(editable);
      }).editable('show');
    } else {
      container.text(points);
    }
  };

  fn._fillTemplate = function(data, template, description, selectedValue) {
    var name = selectedValue.data('name'),
        abbreviation = selectedValue.data('abbreviation') || '',
        baseAttributeGroup = selectedValue.data('base-attribute-group'),
        baseAttributeName = selectedValue.data('base-attribute-name'),
        points = selectedValue.data('value') || 0;

    template.removeClass('template').removeClass('hidden');
    template.attr('data-attribute-name', name);
    template.attr('data-attribute-abbreviation', abbreviation);
    template.attr('data-base-attribute-group', baseAttributeGroup);
    template.attr('data-base-attribute-name', baseAttributeName);
    template.attr('data-points', points);
    template.attr('data-state', 'new');
    template.removeClass('prevent-delete');
    template.find('.smart-description').text(this._nameWithBaseAbbreviation(selectedValue));

    var textRight = template.find('.text-right');

    if (textRight.length > 0) {
      this._newItemInput(data, textRight, points);
    }

    template.find('.qtip-titlebar').text(name);
    template.find('.qtip-content').html(description);

    return template;
  };

  fn._nameWithBaseAbbreviation = function(selectedValue) {
    var name = selectedValue.data('name'),
        baseAttributeGroup = selectedValue.data('base-attribute-group'),
        baseAttributeName = selectedValue.data('base-attribute-name'),
        suffix = '';

    if (baseAttributeGroup && baseAttributeName) {
      var baseAttribute = new GameSystem().getAttribute(baseAttributeGroup, baseAttributeName);

      if (baseAttribute.abbreviation) {
        suffix = ' (' + baseAttribute.abbreviation + ')';
      }
    }

    return name + suffix;
  };

  return SourceTypeListNewItem;
});
