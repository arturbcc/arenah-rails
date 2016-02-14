var ModalReuse = function() {
  this._bindEvents();
};

var fn = ModalReuse.prototype;

fn._bindEvents = function() {
  //Reusing Bootstrap 3 modal to as many links as possible
  $('body').on('hidden.bs.modal', '.modal', function () {
    $(this).removeData('bs.modal');
  });
};
