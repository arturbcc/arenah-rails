// SourceTypeListSelect deals with the lists of new attributes, from which the
// players can select attributes to add to their characters.
define('source-type-list-select', ['game-system', 'attributes-list', 'positive-negative-method', 'based-attribute-method', ], function(GameSystem, AttributesList, PositiveNegativeMethod, BasedAttributeMethod) {
  function SourceTypeListSelect(sheetEditor) {
    this.sheetEditor = sheetEditor;
    this.gameSystem = new GameSystem();
  };

  var fn = SourceTypeListSelect.prototype;

  fn.initialize = function(data) {
    this.select = this.loadNewAttributesList(data);

    this._bindEvents();
  };

  fn.loadNewAttributesList = function(data) {
    var editContainer = data.attributesGroup.find('.editable-list-group'),
        groupMethod = this._groupMethod(editContainer),
        select = editContainer.find('[data-select-new-attribute]'),
        groupName = data.attributesGroup.data('group-name'),
        unusedAttributes = this.gameSystem.unusedAttributesList(groupName, this._usedAttributes(editContainer)),
        attributesList = new AttributesList(groupMethod, unusedAttributes),
        self = this;

    this._removeSelect2Fields();

    select.empty();
    select.append('<option value="0">Selecione...</option>');
    select.append(attributesList.toString());
    select = select.select2({ width: '70%', dropdownParent: $('.modal') });

    if (unusedAttributes.length == 0) {
      select.select2('disable');
    } else {
      select.select2('enable');
    }

    return select;
  };

  fn._bindEvents = function(select) {
    this.select.off('change').on('change', $.proxy(this._selectAttribute, this));
  };

  fn._selectAttribute = function(event) {
    var select = $(event.currentTarget),
        index = select.prop('selectedIndex'),
        descriptionContainer = select.siblings('.editable-current-item-description');

    descriptionContainer.html('');

    if (index > 0) {
      var selectedValue = select.find(':selected'),
          name = selectedValue.data('name'),
          abbreviation = selectedValue.data('abbreviation') || '';

      descriptionContainer.html(this._buildDescriptionContainer(name));
      descriptionContainer.show();
    }
  };

  fn._buildDescriptionContainer = function(attributeName) {
    var table = $('<table>'),
        tr = $('<tr>'),
        td = $('<td>'),
        qtipTitle = $('<div>'),
        qtipContent = $('<div>');

    qtipTitle.addClass('qtip-titlebar').html(attributeName);

    var content = this._fetchItemDescription(attributeName);
    qtipContent.addClass('qtip-content').html(content);
    td.append(qtipTitle).append(qtipContent);
    tr.append(td);
    table.append(tr).css(this._attributeDescriptionStyle());

    return table;
  };

  fn._attributeDescriptionStyle = function() {
    return {
      width: '90%',
      margin: '5px auto',
      padding: '5px',
      border: '1px solid #000',
      backgroundColor: '#fff',
      boxShadow: '3px 3px 3px #675D5D'
    };
  };

  fn._fetchItemDescription = function(name) {
    var data = this.sheetEditor.currentAttributesGroupData(this.select),
        groupName = data.attributesGroup.data('group-name'),
        list = this.gameSystem.listOfAttributes(groupName);

    var item = $.grep(list, function (item) { return item.name === name; });
    return item != undefined && item[0].description ? item[0].description : 'Sem descrição';
  };

  fn._removeSelect2Fields = function() {
    $('.select2-container').remove();
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

  fn._groupMethod = function(container) {
    return container.parent().data('type') == 'based' ? new BasedAttributeMethod() : new PositiveNegativeMethod();
  };

  return SourceTypeListSelect;
});
