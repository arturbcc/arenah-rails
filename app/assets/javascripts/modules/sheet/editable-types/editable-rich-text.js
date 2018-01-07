define('editable-rich-text', ['transform'], function(Transform) {
  function EditableRichText(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this.transform = this.transformer.toCKEditor;
  };

  var fn = EditableRichText.prototype;

  return EditableRichText;
});
