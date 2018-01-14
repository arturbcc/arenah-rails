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

  return EditableBased;
});
