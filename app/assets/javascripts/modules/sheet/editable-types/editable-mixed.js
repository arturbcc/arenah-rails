define('editable-mixed', ['transform'], function(Transform) {
  function EditableMixed(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);
  };

  var fn = EditableMixed.prototype;

  fn.transform = function(editable) {
    var editType = editable.$element.data('editable-attribute');

    if (editType === 'spinner') {
     this.transformer.inputToSpinner(editable.input.$input);
     editable.$element.parent().find('.ui-spinner-button').addClass('ui-state-default');
    }
  };

  // Because the mixed group can have more than one input in each
  // attribute, the `element` parameter can be an array. In this case, we use
  // the first one for the `point` and the second one for the `total`.
  fn.updateSheetWithNewValues = function(element, change, equipmentModifier, tr) {
    var value = parseInt(change.value);

    if (change.field_name === 'points') {
      if (element.length > 1) {
        element = $(element[0]);
      }
      element.attr('data-value', value);
      element.html(value + equipmentModifier);

      tr.attr('data-points', value);
    } else if (change.field_name === 'total') {
      if (element.length > 1) {
        element = $(element[1]);
      }
      element.attr('data-value', value);
      element.html(value + equipmentModifier);

      // var totalLabel = tr.find('.attribute-total-value');
      // totalLabel.html(value);
      tr.attr('data-value', value);
    } else {
      element.attr('data-value', value);
    }
  };

  return EditableMixed;
});
