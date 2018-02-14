define('editable-text', ['transform', 'source-type-list', 'source-type-open'], function(Transform, SourceTypeList, SourceTypeOpen) {
  function EditableText(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this._initialize(data);
  };

  var fn = EditableText.prototype;

  fn._initialize = function(data) {
    var sourceType = data.attributesGroup.data('source-type');

    if (sourceType === 'list') {
      this.sourceTypeList = new SourceTypeList(this.sheetEditor, data);
      this.transform = this.sourceTypeList.transform;
    } else if (sourceType === 'open') {
      this.sourceTypeList = new SourceTypeOpen(this.sheetEditor, data);
      this.transform = this.sourceTypeList.transform;
    }
  };

  fn.onCancel = function(data) {
    if (this.sourceTypeList) {
      this.sourceTypeList.onCancel(data);
    }
  };

  // When the source of the group is list we need to delegate the `closing`
  // behaviour to the sourceTypeList object. It will cleanup all resources
  // and hide one of the panels that are displayed to the users.
  fn.afterSave = function(data, _) {
    if (this.sourceTypeList) {
      this.sourceTypeList.leaveEditMode(data);
    }
  };

  return EditableText;
});
