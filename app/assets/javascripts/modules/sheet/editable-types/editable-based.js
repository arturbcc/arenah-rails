define('editable-based', ['transform', 'source-type-list'], function(Transform, SourceTypeList) {
  function EditableBased(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
    this.transformer = new Transform(sheetEditor);

    this.sourceTypeList = new SourceTypeList(sheetEditor);

    this._initialize(data);
  };

  var fn = EditableBased.prototype;

  fn.initialize = function(data) {
    var sourceType = data.attributesGroup.attr('data-source-type');

    this.transform = this.tranformer.toSpinner;
    data.attributesGroup.find('.based-warning').show();

    if (sourceType === 'List') {
      data.attributesGroup.find('.attributes-with-base').hide();
      this._overrideListFunctions(data);
    }
  };

  fn._overrideListFunctions = function (data) {
    var list = $.extend({}, this.sourceTypeList);
    list.initialize(data);

    list.transform = function(editable) {
      return false;
    };

    list.onNewItem = function(item) {
      var input = item.find('.new-list-item input');

      input.val(0);
      this.transformer.inputToSpinner(input);
      item.find('.ui-spinner-button').addClass('ui-state-default');

      var abbreviation = item.data('attribute-abbreviation') || '0',
          name = item.find('.smart-description').text();

      item.find('.smart-description').text(name + ' (' + abbreviation + ')');
    };

    list.inputNewItem = function (container, points) {
      content = '<span class="new-list-item editable-container editable-inline"><div><form class="form-inline editableform"><div class="control-group form-group"><div><div class="editable-input" style="position: relative;"><input data-mark="new-input" type="text" class="form-control input-sm" style="padding-right: 24px;"><span class="editable-clear-x" style="display: inline;"></span></div></div></div></form></div></span>';
      container.html(content);
      return false;
    };

    list.onSelectItemName = function (item) {
      return item.Name + ' (' + (item.abbreviation ? item.abbreviation : '0') + ')';
    }
  };

  fn._onCancel = function(data) {
    data.attributesGroup.find('.based-warning').hide();
    data.attributesGroup.find('.attributes-with-base').show();

    var editContainer = data.attributesGroup.find('.editable-list-group');
    editContainer.removeClass('edit-mode').addClass('hidden');

    data.attributesGroup.find('[data-editable-attribute]').each(function() {
      $(this).editable('hide');
    });
  }

  return EditableBased;
});
