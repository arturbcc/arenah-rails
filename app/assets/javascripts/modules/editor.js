define('editor', [], function() {
  function Editor(container) {
    this.container = $(container || '[data-bbcode-editor]')
    this.bindEvents();
  };

  var fn = Editor.prototype;

  fn.bindEvents = function() {
    this.container.markItUp(simpleSettings);
  };

  return Editor;
});
