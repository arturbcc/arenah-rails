define('editable-character-card', [], function() {
  function EditableCharacterCard(sheetEditor, data) {
    this.sheetEditor = sheetEditor;
  };

  var fn = EditableCharacterCard.prototype;

  fn.onSave = function(changes) {
    $.each(changes.character_attributes, function(_, change) {
      $('tr[data-attribute-name="' + change.attribute_name + '"] .value a').html(change.value);
    });
  };

  return EditableCharacterCard;
});
