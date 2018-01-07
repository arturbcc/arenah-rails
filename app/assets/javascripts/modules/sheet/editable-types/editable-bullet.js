define('editable-bullet', ['transform'], function(Transform) {
  function EditableBullet(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);
  };

  var fn = EditableBullet.prototype;

  fn.transform = function(editable) {
    editable.$element.parent().find('.pull-right').hide();
    this.transformer.toSpinner(editable);
  };

  fn.onCancel = function(data) {
    data.attributesGroup.find('.pull-right').show();
    data.attributesGroup.find('.bullet-hidden').hide();
  };

  return EditableBullet;
});
