define('editable-character-card', [], function() {
  function EditableCharacterCard(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
  };

  var fn = EditableCharacterCard.prototype;

  fn.onSave = function(data) {
    var inputs = data.attributesGroup.find('.editableform input');

    $.each(inputs, function() {
      var input = $(this),
          attributeName = input.parents('tr[data-attribute-name]'),
          attributeValue = input.val();

      console.log(tr.data('attribute-name'));
    });
  };

  return EditableCharacterCard;
});
