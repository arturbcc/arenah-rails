define('editable-equipments', [], function() {
  function EditableEquipments(sheetEditor, data) {
    this.sheetEditor = sheetEditor;

    this._closeModal();

    $.get(this.sheetEditor.equipmentsUrl, function(data) {
      var template = '<div class="modal-dialog"><div class="modal-content">' + data + '</div></div>';
      $('#remoteModal').html(template);
      $('.modal').modal('show');
      $('.modal').on('hide.bs.modal', function() {
        $(".modal-backdrop").remove();
      })
    });
  };

  var fn = EditableEquipments.prototype;

  fn._closeModal = function() {
    $('.modal').modal('hide');
  };

  return EditableEquipments;
});
