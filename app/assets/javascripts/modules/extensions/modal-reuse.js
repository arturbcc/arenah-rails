define('modal-reuse', [], function() {
  function ModalReuse() {
    this._bindEvents();
  };

  var fn = ModalReuse.prototype;

  fn._bindEvents = function() {
    $('body').on('hidden.bs.modal', '.modal', this._allowModalReuse);
  };

  fn._allowModalReuse = function(e) {
    $(this).removeData('bs.modal');
  };

  return ModalReuse;
});
