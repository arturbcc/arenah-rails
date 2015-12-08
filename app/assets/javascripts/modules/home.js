var Home = function Home() {
  this.headerThreshold = 50;
  this.scrollAnimationTime = 1500;

  this.animateHeader(this.headerThreshold);
  this.configurePageScroll(this.scrollAnimationTime);
};

var fn = Home.prototype;

fn.animateHeader = function(threshold) {
  $(window).scroll(function () {
    if ($('.navbar').offset().top > threshold) {
      $('.gold').removeClass('gold');
      $('.navbar-fixed-top').addClass('top-nav-collapse');
    } else {
      $('.navbar-fixed-top').removeClass('top-nav-collapse');
    }
  });
};

//jQuery for page scrolling feature - requires jQuery Easing plugin
fn.configurePageScroll = function(scrollAnimationTime) {
  $('.page-scroll a').on('click', function (event) {
    var anchor = $(this),
        href = anchor.attr('href');

    $('html, body').stop().animate({
      scrollTop: $(href).offset().top
    }, scrollAnimationTime, 'easeInOutExpo');

    event.preventDefault();
  });

  $('.page-scroll').mouseover(function () {
    $('.gold').removeClass('gold');
  });
};
