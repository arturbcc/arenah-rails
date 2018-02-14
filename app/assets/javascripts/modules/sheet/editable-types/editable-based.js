define('editable-based', ['transform', 'source-type-list'], function(Transform, SourceTypeList) {
  function EditableBased(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);
    this.sourceTypeList = new SourceTypeList(sheetEditor, data);

    this._initialize(data);
  };

  var fn = EditableBased.prototype;

  fn._initialize = function(data) {
    var sourceType = data.attributesGroup.attr('data-source-type');

    this.transform = this.transformer.toSpinner;
    data.attributesGroup.find('.based-warning').show();
  };

  fn.onCancel = function(data) {
    data.attributesGroup.find('.based-warning').hide();
    data.attributesGroup.find('.attributes-with-base').show();
    data.attributesGroup.find('.editable-current-item-description').hide();

    var editContainer = data.attributesGroup.find('.editable-list-group');
    editContainer.removeClass('edit-mode').addClass('hidden');

    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });

    var sourceType = data.attributesGroup.attr('data-source-type');
    if (sourceType === 'list') {
      this.sourceTypeList.onCancel(data);
    }
  };

  fn.updateSheetWithNewValues = function(element, change, equipmentModifier, tr) {
    var parts = element.text().split(' / '),
        value = parseInt(change.value),
        difference = parseInt(parts[1]) - parseInt(parts[0]),
        total = value + difference,
        newText = value + ' / ' + total;

    element.text(newText);
    if (element.hasClass('editable')) {
      element.attr('data-value', value);
    }

    tr.attr('data-points', value);
    tr.attr('data-value', total);
  };

  // When the source of the group is list we need to delegate the `closing`
  // behaviour to the sourceTypeList object. It will cleanup all resources
  // and hide one of the panels that are displayed to the users.
  fn.afterSave = function(data, _) {
    var sourceType = data.attributesGroup.attr('data-source-type');
    if (sourceType === 'list') {
      this.sourceTypeList.leaveEditMode(data);
    }
  };

  fn.formatAddedAttribute = function(element) {
    var value = parseInt(element.find('a[data-editable-attribute]').data('value')),
        tr = element.parent(),
        baseAttributeGroup = tr.data('base-attribute-group'),
        baseAttributeName = tr.data('base-attribute-name'),
        total = value;

    if (baseAttributeGroup && baseAttributeName) {
      var group = $('#sheet').find('.attributes-group[data-group-name="' + baseAttributeGroup + '"]'),
          attribute = group.find('[data-accept-edit-mode] tr[data-attribute-name="' + baseAttributeName + '"]'),
          equipmentModifier = parseInt(attribute.data('equipment-modifier') || 0);

      total += (parseInt(attribute.attr('data-points')) + equipmentModifier);
    }

    tr.attr('data-value', total);
    element.html('');
    element.append($('<a>').attr('href', 'javascript:;').text(value + ' / ' + total));
  };

  return EditableBased;
});
