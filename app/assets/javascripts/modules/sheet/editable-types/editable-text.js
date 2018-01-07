define('editable-text', ['transform', 'source-type-list', 'source-type-open'],
  function(Transform, SourceTypeList, SourceTypeOpen) {

  function EditableText(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    var sourceType = data.attributesGroup.data('source-type');

    if (sourceType === 'list') {
      return new SourceTypeList(this.sheetEditor, data);
    } else if (sourceType === 'open') {
      return new SourceTypeOpen(this.sheetEditor, data);
    }
  };

  var fn = EditableText.prototype;

  return EditableText;
});
