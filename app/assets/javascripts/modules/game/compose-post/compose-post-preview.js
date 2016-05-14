define('compose-post-preview', ['bbcode'], function(BBCode) {
  function ComposePostPreview(button, container) {
    this.previewButton = $(button);
    this.container = $(container);

    this._bindEvents();
  };

  var fn = ComposePostPreview.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, 'onPreview');

    this.previewButton.on('click', this.onPreview);
  };

  fn.onPreview = function(event) {
    event.preventDefault();
    var self = this;

    $.ajax({
      url: self.container.data('url'),
      data: {
        message: $('#bbcode-editor').val()
      },
      type: 'POST',
      success: function(data) {
        self.container
          .html(data)
          .find('.post-preview-modal')
          .modal('show');

        new BBCode();
      }
    });
  };

  return ComposePostPreview;
});
