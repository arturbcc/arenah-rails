define('editable-name-value', ['transform', 'source-type-list'], function(Transform, SourceTypeList) {
  function EditableNameValue(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this._initialize(data);
  };

  var fn = EditableNameValue.prototype;

  fn._initialize = function(data) {
    var sourceType = data.attributesGroup.data('source-type');

    if (sourceType === 'list') {
      this.sourceTypeList = new SourceTypeList(this.sheetEditor, data);
      this.transform = this.sourceTypeList.transform;
    } else if (sourceType === 'fixed') {
      this.transform = this.transformer.toSpinner;
    }
  };

  fn.onCancel = function(data) {
    var sourceType = data.attributesGroup.attr('data-source-type');
    if (sourceType === 'list') {
      this.sourceTypeList.onCancel(data);
    }
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

  fn.updateSheetWithNewValues = function(element, change, equipmentModifier, tr) {
    var value = parseInt(change.value);

    element.attr('data-value', value);
    element.html(value + equipmentModifier);

    tr.attr('data-points', value);
  };

  return EditableNameValue;
});
