define('editable-name-value', ['transform', 'source-type-list'], function(Transform, SourceTypeList) {
  function EditableNameValue(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this.onCancel = null;
    this.transform = null;

    return this._initialize(data);
  };

  var fn = EditableNameValue.prototype;

  fn._initialize = function(data) {
    var sourceType = data.attributesGroup.data('source-type');

    if (sourceType === 'list') {
      return new SourceTypeList(this.sheetEditor, data);
    } else if (sourceType === 'fixed') {
      this.transform = this.transformer.toSpinner;
      return this;
    }
  };

  fn.onSave = function(data) {
    var keys = Object.keys(changes.character_attributes);

    $.each(keys, function(_, attributeName) {
      $('tr[data-attribute-name="' + attributeName + '"] a[data-editable-attribute]')
        .html(changes.character_attributes[attributeName].value);
    });
  };


  return EditableNameValue;
});
