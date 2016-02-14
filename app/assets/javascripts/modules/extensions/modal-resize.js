var ModalResize = function() {
  this._bindEvents();
};

var fn = ModalResize.prototype;

fn._bindEvents = function() {
  //Setting the width of the modal with a data-attribute
  $("[data-toggle=modal]").click(function () {
    $('.modal-dialog').css("width", $(this).attr("data-width"));
  });
};
