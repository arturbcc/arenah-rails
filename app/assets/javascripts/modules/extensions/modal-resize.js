define('modal-resize', [], function() {
  function ModalResize() {
    this._bindEvents();
  };

  var fn = ModalResize.prototype;

  fn._bindEvents = function() {
    $('[data-toggle=modal]').on('click', $.proxy(this._resizeModal, this));
  };

  fn._resizeModal = function(e) {
    $('.modal-dialog').css('width', $(event.target).attr('data-width'));
  };

  return ModalResize;
});
