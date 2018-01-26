define('editable-character-card', [], function() {
  function EditableCharacterCard(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
  };

  var fn = EditableCharacterCard.prototype;

  fn.onSave = function(data) {
    var inputs = data.attributesGroup.find('.editableform input'),
        changes = { group_name: data.attributesGroup.data('group-name'), character_attributes: {} };

    $.each(inputs, function() {
      var input = $(this),
          tr = input.parents('tr[data-attribute-name]'),
          attributeName = tr.data('attribute-name'),
          attributeValue = input.val();

          changes.character_attributes[attributeName] = { field_name: 'content', value: attributeValue };
    });

    return changes;
  };

  return EditableCharacterCard;
});
