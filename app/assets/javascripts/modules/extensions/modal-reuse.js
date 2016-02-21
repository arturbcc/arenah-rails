define('modal-reuse', [], function() {
  function ModalReuse() {
    this._bindEvents();
  };

  var fn = ModalReuse.prototype;

  fn._bindEvents = function() {
    $('body').on('hidden.bs.modal', '.modal', $.proxy(this._allowModalReuse, this));
  };

  fn._allowModalReuse = function(e) {
    $(event.target).removeData('bs.modal');
  };

  return ModalReuse;
});
