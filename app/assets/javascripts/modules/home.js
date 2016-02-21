define('home', [], function() {
  var onScrollWatcher = require('on-scroll-watcher');

  function Home(options) {
    options = options || {};

    this.threshold = options.threshold || 50;
    this.scrollAnimationTime = options.scrollAnimationTime || 1500;

    this._bindEvents();
  };

  var fn = Home.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_animateHeader',
      '_scrollToSection');

    new onScrollWatcher(this._animateHeader);

    $('.page-scroll a').on('click', this._scrollToSection);
  };

  fn._animateHeader = function() {
    var klass = 'top-nav-collapse',
        top = $('.navbar').offset().top,
        element = $('.navbar-fixed-top');

    if (top > this.threshold) {
      this._removeGold();
      element.addClass(klass);
    } else {
      element.removeClass(klass);
    }
  };

  // jQuery for page scrolling feature -
  // it requires jQuery Easing plugin
  fn._scrollToSection = function(e) {
    var href = $(e.target).attr('href'),
        self = this;

    $('html, body').stop().animate({
      scrollTop: $(href).offset().top
    }, self.scrollAnimationTime, 'easeInOutExpo');

    event.preventDefault();
  };

  fn._removeGold = function() {
    $('.nav .active').removeClass('active');
  };

  return Home;
});
