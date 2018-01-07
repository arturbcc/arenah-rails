define('transform', [], function() {
  function Transform(sheetEditor) {
    this.sheetEditor = sheetEditor;

    $.proxyAll(
      this,
      'toCKEditor',
      'toSpinner'
    );
  };

  var fn = Transform.prototype;

  fn.toCKEditor = function(editable) {
    var name = editable.$element.data('name');
    editable.input.$input.attr('name', name)
    var content = editable.$element.siblings('textarea').val();
    editable.input.$input.val(content);

    var editor = CKEDITOR.instances[name];
    if (editor) {
      delete CKEDITOR.instances[name];
    }

    CKEDITOR.replace(name, {
      width: '890px',
      height: '700px',
      toolbar: 'short'
    });

    CKEDITOR.instances[name].setData(content);
  };

  fn.toSpinner = function(editable) {
    var inputSpinners = editable.$element.parent().find('input');

    this.inputToSpinner(inputSpinners);
    $('.editable-input .ui-spinner-button').addClass('ui-state-default');
  };

  fn.inputToSpinner = function(input) {
    var self = this;

    input.spinner({
      spin: function (event, ui) {
        data = self.sheetEditor.currentAttributesGroupData(this);

        var currentValue = $(this).spinner('value'),
            newValue = ui.value,
            attributeOriginalPoints = parseInt($(this).parents('.editable-inline').prev().data('value'));

        data.usedPoints = data.usedPoints + (newValue - currentValue);

        var exceededLimit = data.points && data.usedPoints > data.points,
            decreasedAttributeValue = newValue < attributeOriginalPoints;

        if (self.sheetEditor.isMaster || self.sheetEditor.freeMode) {
          decreasedAttributeValue = false;
        }

        if (exceededLimit || decreasedAttributeValue) {
          return false;
        } else {
          self.sheetEditor.changeAttributePoints(data);
        }
      }
    });
  };

  return Transform;
});
