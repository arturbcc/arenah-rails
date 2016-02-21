define('on-scroll-watcher', [], function() {
  function OnScrollWatcher(callback) {
    this.callback = callback;

    if (typeof(callback) == 'function') {
      this._bindEvents();
    }
  };

  var fn = OnScrollWatcher.prototype;

  fn._bindEvents = function() {
    var didScroll = false,
        self = this;

    window.onscroll = function() {
      didScroll = true;
    };

    setInterval(function() {
      if (didScroll) {
        didScroll = false;
        self.callback();
      }
    }, 100);
  };

  return OnScrollWatcher
});
