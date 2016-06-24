define('editable-name-value', ['transform', 'source-type-list'], function(Transform, SourceTypeList) {
  function EditableNameValue(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this.onCancel = null;
    this.transform = null;

    this._initialize(data);
  };

  var fn = EditableNameValue.prototype;

  fn._initialize = function(data) {
    var sourceType = data.attributesGroup.data('source-type');

    if (sourceType === 'List') {
      return new SourceTypeList(this.sheetEditor, data);
    } else if (sourceType === 'Fixed') {
      this.transform = this.transformer.toSpinner;
    }
  };

  return EditableNameValue;
});
