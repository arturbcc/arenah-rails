//TODO: Loose this coupling between rules-panel and compose-post-attribute-selection
define('rules-panel', [], function() {
  function RulesPanel(options) {
    this.attributes = [];

    this.container = $('#collapseFour');
    this.attributesArea = $('#attributes-area');
    this.results = $('.tests-result');
    this.clearButton = this.container.find('.btn-danger');
    this.rollButton = this.container.find('btn-success');
    this.attributeTemplate = $('.character-attribute-line-template');

    this._bindEvents();
  };

  var fn = RulesPanel.prototype;

  fn._bindEvents = function() {
    var self = this;

    $.proxyAll(this,
      '_clear',
      '_recalculatePositions',
      '_removeAttribute',
      '_roll');

    // Insert event observers inside this if. The rules panel is being loaded
    // every time a sheet is opened and the events may be duplicated if any
    // binding is made outside this if
    if (!this.container.data('loaded')) {
      this.clearButton.on('click', this._clear);

      this.attributesArea.sortable({
        stop: function (event, ui) {
          self.attributesArea.find('.odd').removeClass('odd');
          self.recalculatePositions();
        }
      });

      this.attributesArea.on('click', '[data-remove-attribute]', this._removeAttribute);
    }

    this.container.attr('data-loaded', 'true');
  };

  fn.attributesCount = function() {
    return this.attributes.length;
  };

  fn.addAttribute = function(data) {
    var template = this.attributeTemplate.clone();

    template.removeClass('character-attribute-line-template');
    template.data({
      'attribute-name': data.attributeName,
      'character-name': data.name,
      'character-id': data.id
    });

    data.position = this.attributes.length + 1;
    data.originalPosition = data.position;

    $('.attribute-position', template).html(data.position);
    $('[data-original-position]', template).val(data.position);

    var img = $('img', template);
    img.attr('src', img.data('path').replace('AVATAR.png', data.avatar));
    img.attr('alt', data.name);
    img.attr('title', data.name + ' (' + data.attributeName + ')');
    img.qtip({
      style: { classes: 'qtip-tipsy' },
      position: { my: 'top center', at: 'bottom center'}
    });

    $('.attribute', template).html(
      "<option value='" + data.value + "'>" + data.value + " [Valor]</option> " +
      "<option value='" + data.points + "'>" + data.points + " [Pontos]</option> "
    );

    if (this.attributes.length % 2 == 1) {
      template.addClass('odd');
    }

    if (this.attributes.length === 0) {
      this.attributesArea.html(template);
    } else {
      this.attributesArea.append(template);
    }

    this.attributes.push(data);
    this._updateBadgeCount();
  };

  fn.roll = function() {

  };

  fn._clear = function() {
    this.attributes = [];

    this.attributesArea.html(this._emptyMessage());
    this.results.html('').css('background-color', 'transparent');

    $('.tests-result.on').removeClass('on');
  };

  fn._emptyMessage = function() {
    var icon = $('<i>').addClass('fa fa-spinner fa-spin');

    return $('<div>')
      .addClass('splash')
      .append(icon)
      .append(' Escolha os atributos nas fichas');
  };

  fn._updateBadgeCount = function() {
    var badge = $('#rules-set-box-attributes'),
        redBadgeClass = 'red-badge';

    if (this.attributes.length > 0) {
      badge.addClass(redBadgeClass);
    } else {
      badge.removeClass(redBadgeClass);
    }

    badge.text(this.attributes.length);
  };

  fn._recalculatePositions = function() {
    var self = this,
        index = 0;

    $('#attributes-area .character-attribute-line').each(function (_, item) {
      var position = index + 1,
          originalPosition = $('[data-original-position]', item).val(),
          attribute = this._findAttribute(originalPosition);

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

  fn._removeAttribute = function(e) {
    var element = $(e.currentTarget),
        line = element.parents('.character-attribute-line'),
        originalPosition = $('[data-original-position]', line).val(),
        attribute = this._findAttribute(originalPosition),
        index = this.attributes.indexOf(attribute),
        self = this;

    line.fadeOut();
    this.attributes.splice(index, 1);
    this._updateBadgeCount();

    if (this.attributes.length === 0) {
      this._clear();
    }

    line.remove();
    this._recalculatePositions();
  };

  fn._findAttribute = function(originalPosition) {
    return $.grep(this.attributes, function (e) { return e.originalPosition == originalPosition; })[0];
  };

// $("#collapseFour .btn-success").on("click", function () {
//   self.attributesTest();
// });
//

  return RulesPanel;
});
