define('modal-reuse', [], function() {
  function ModalReuse() {
    this._bindEvents();
  };

  var fn = ModalReuse.prototype;

  fn._bindEvents = function() {
    $('body').on('hidden.bs.modal', '.modal', this._allowModalReuse);
  };

  fn._allowModalReuse = function(e) {
    var img = $('<img>').attr('src', '/images/loader.gif');
    var loading = $('<div />').addClass('loading-modal').append(img);

    $('.modal-content').html(loading);
    $(this).removeData('bs.modal');
  };

  return ModalReuse;
});
