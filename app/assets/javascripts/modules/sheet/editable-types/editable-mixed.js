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

  return EditableMixed;
});
