define('modal-resize', [], function() {
  function ModalResize() {
    this._bindEvents();
  };

  var fn = ModalResize.prototype;

  fn._bindEvents = function() {
    $('[data-toggle=modal]').on('click', this._resizeModal);
  };

  fn._resizeModal = function(e) {
    $('.modal-dialog').css('width', $(this).attr('data-width'));
  };

  return ModalResize;
});
