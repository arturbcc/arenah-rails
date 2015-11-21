var OnlineUsers = function() {
  this.container = $('[online-users]');
  this.container.lockOnFooter();
};

var fn = OnlineUsers.prototype;

fn.lock = function() {
  this.container.lockOnFooter()
};

$.fn.lockOnFooter = function () {
  var container = $(this),
      id = container.attr("id"),
      threshold = 100;

  $(window).scroll(function () {
    var scrollPosition = $(this).scrollBottom();

    if (scrollPosition < threshold) {
      container.removeClass("normal").addClass("over-footer-position");
    } else if (container.hasClass("over-footer-position")) {
      container.removeClass("over-footer-position").addClass("normal-position");
    }
  });
};
