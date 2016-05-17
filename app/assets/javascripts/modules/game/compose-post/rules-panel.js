//TODO: Loose this coupling between rules-panel and compose-post-attribute-selection
define('rules-panel', [], function() {
  function RulesPanel(options) {
    this.onClearCallback = options['onClear'];
    this.findAttribute = options['findAttribute'];

    this.container = $('#collapseFour');
    this.attributesArea = $('#attributes-area');
    this.results = $('.tests-result');
    this.clearButton = this.container.find('.btn-danger');
    this.rollButton = this.container.find('btn-success');

    this._bindEvents();
  };

  var fn = RulesPanel.prototype;

  fn._bindEvents = function() {
    var self = this;

    $.proxyAll(this, 'clear', 'roll', 'recalculatePositions');

    if (!this.container.data('loaded')) {
      this.clearButton.on('click', this.clear);
      this.attributesArea.sortable({
        stop: function (event, ui) {
          self.attributesArea.find('.odd').removeClass('odd');
          self.recalculatePositions();
        }
      });
    }

    this.container.attr('data-loaded', 'true');
  };

  fn.clear = function() {
    if (this.onClearCallback && typeof(this.onClearCallback) === 'function') {
      this.onClearCallback();
    }

    this.attributesArea.html(this._emptyMessage());
    this.results.html('').css('background-color', 'transparent');

    $('.tests-result.on').removeClass('on');
  };

  fn.roll = function() {

  };

  fn._emptyMessage = function() {
    var icon = $('<i>').addClass('fa fa-spinner fa-spin');

    return $('<div>')
      .addClass('splash')
      .append(icon)
      .append(' Escolha os atributos nas fichas');
  };

  // fn._findAttribute = function(originalPosition) {
  //   return $.grep(this.attributes, function (e) { return e.originalPosition == originalPosition; })[0];
  // };

  fn.recalculatePositions = function() {
    var self = this,
        index = 0;

    $('#attributes-area .character-attribute-line').each(function (_, item) {
      var position = index + 1,
          originalPosition = $('[data-original-position]', item).val(),
          attribute;

      if (self.findAttribute && typeof(self.findAttribute) === 'function') {
        attribute = self.findAttribute(originalPosition);
      }

      if (attribute) {
        attribute.position = position;
        $('.attribute-position', item).text(position);

        if (index % 2 == 1) {
          $(item).addClass('odd');
        }

        index += 1;
      }
    });
  };

// $("#collapseFour .btn-success").on("click", function () {
//   self.attributesTest();
// });
//

  return RulesPanel;
});
