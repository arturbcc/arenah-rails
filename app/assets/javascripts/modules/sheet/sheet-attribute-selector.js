define('sheet-attribute-selector', [], function() {
  function SheetAttributeSelector(options = {}) {
    this.selectedAttribute = null;
    this.callback = options['onSelect'];
    this.sheet = $('#sheet');
    this.tools = $('#sheet-tools');
    this.attributes = $('[data-group-name] tr');

    this._bindEvents();
  };

  var fn = SheetAttributeSelector.prototype;

  fn._bindEvents = function() {
    var self = this;

    $.proxyAll(this,
      '_showSelector',
      '_closeSelector',
      '_selectAttribute'
    );

    this.tools.find('.close-tools').on('click', this._closeSelector);

    if (typeof this.callback === 'function') {
      this.attributes.on('click', this._showSelector);
      this.tools.find('.select-attribute').on('click', function() {
        self._selectAttribute(self.selectedAttribute);
      });
    }
  };

  fn._showSelector = function(e) {
    var attribute = $(e.currentTarget),
        element = attribute.find('a:eq(0)'),
        position = this._anchorPosition(element);

    this.tools.find('span').html(element.text());
    this.tools.css('top', position.top).css('left', position.left);
    this.tools.css('width', attribute.parent().parent().css('width'));
    this.selectedAttribute = attribute;

    this.tools.show();
  };

  fn._closeSelector = function() {
    this.tools.hide();
  };

  fn._selectAttribute = function() {
    this.callback(this.selectedAttribute);
  };

  fn._anchorPosition = function(element) {
    var gutter = 3;
    return {
      'top': element.offset().top - this.sheet.offset().top - 2 * gutter,
      'left': element.offset().left - this.sheet.offset().left - gutter
    };
  };

  return SheetAttributeSelector;
});
