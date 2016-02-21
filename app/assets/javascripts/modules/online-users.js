define ('online-users', [], function() {
  var onScrollWatcher = require('on-scroll-watcher');

  function OnlineUsers(container, options) {
    this.container = $(container);

    options = options || {};
    this.threshold = options.threshold || 100;

    this._bindEvents();
  };

  var fn = OnlineUsers.prototype;

  fn._bindEvents = function() {
    new onScrollWatcher($.proxy(this._lockOnFooter, this));
  };

  fn._lockOnFooter = function() {
    var scrollPosition = this.container.scrollBottom();

    if (scrollPosition < this.threshold) {
      this.container
        .removeClass('normal')
        .addClass('over-footer-position');
    } else if (this.container.hasClass('over-footer-position')) {
      this.container
        .removeClass('over-footer-position')
        .addClass('normal-position');
    }
  };

  return OnlineUsers;
});
