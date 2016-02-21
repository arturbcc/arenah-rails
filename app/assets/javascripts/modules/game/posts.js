define('post', [], function() {
  function Post(topic) {
    this.topic = topic;
    this.posts = $('[data-post]');
    this.authors = $('[data-author]');
    this.avatar = this.authors.find('[data-flip-avatar]');
    this.closeAvatar = this.authors.find('[data-unflip]');
    this.deletePost = this.posts.find('[data-delete-post]');

    this._bindEvents();
  }

  var fn = Post.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_flipAvatar',
      '_unflipAvatar',
      '_destroy'
    )

    this.avatar.on('click', this._flipAvatar);
    this.closeAvatar.on('click', this._unflipAvatar);
    this.deletePost.on('click', this._destroy);
  };

  fn._flipAvatar = function(event) {
    $(event.target).closest('[data-flip-panel]').addClass('flip');
  };

  fn._unflipAvatar = function(event) {
    $(event.target).closest('[data-flip-panel]').removeClass('flip');
    event.preventDefault();
  };

  fn._destroy = function (event) {
    if (confirm('Tem certeza que deseja excluir?')) {
      var $el = $(event.target),
          id = $el.data('post-id'),
          url = $el.data('delete-post');

      $.ajax({
        url: url,
        type: 'DELETE',
        success: function(data) {
          if (data.status == 200) {
            $el.parents('[data-post]').fadeOut();
          } else {
            NotyMessage.show('Não é possível apagar a postagem', 3000);
          }
        }
      });
    }
  };

  return Post;
});
