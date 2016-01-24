var Post = function(topic) {
  this.topic = topic;
  this.posts = $('[data-post]');
  this.authors = $('[data-author]');
  this.avatar = this.authors.find('[data-flip-avatar]');
  this.closeAvatar = this.authors.find('[data-unflip]');
  this.deletePost = this.posts.find('[data-delete-post]');

  this.bindEvents();
}

var fn = Post.prototype;

fn.bindEvents = function() {
  this.avatar.on('click', $.proxy(this.flipAvatar, this));
  this.closeAvatar.on('click', $.proxy(this.unflipAvatar, this));
  this.deletePost.on('click', $.proxy(this.destroy, this));
};

fn.flipAvatar = function(event) {
  $(event.target).closest('[data-flip-panel]').addClass('flip');
};

fn.unflipAvatar = function(event) {
  $(event.target).closest('[data-flip-panel]').removeClass('flip');
  event.preventDefault();
};

fn.destroy = function (event) {
  if (confirm('Tem certeza que deseja excluir?')) {
    var $el = $(event.target),
        id = $el.data('post-id'),
        url = $el.data('delete-post');

    $.ajax({
      url: url,
      type: 'DELETE',
      success: function(data) {
        if (data.Status != 'OK') {
          NotyMessage.show("Não é possível apagar a postagem", 3000);
        } else {
          $el.closest('data-post').fadeOut();
        }
      }
    });
  }
};
