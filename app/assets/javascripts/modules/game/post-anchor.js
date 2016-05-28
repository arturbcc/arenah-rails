define('post-anchor', [], function() {
  function PostAnchor() {
    var postId = window.location.hash.substr(1);

    if (postId) {
      this._scrollToPost(postId);
    }
  };

  var fn = PostAnchor.prototype;

  fn._scrollToPost = function(postId) {
    var post = $('[name="' + postId + '"]').parents('[data-post]');

    $('html, body').stop().animate({
      scrollTop: post.offset().top - 40
    }, null, 'easeInOutExpo');
  };

  return PostAnchor;
});
