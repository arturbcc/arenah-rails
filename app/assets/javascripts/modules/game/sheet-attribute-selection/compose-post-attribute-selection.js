define('compose-post-attribute-selection', [], function() {
  function ComposePostAttributeSelection(game) {
    this.game = game;
    this.attributes = [];

    this._bindEvents();
  };

  var fn = ComposePostAttributeSelection.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, 'selectionCallback', '_removeAttribute');

    $('#attributes-area').on('click', '[data-remove-attribute]', this._removeAttribute);
  };

  fn.selectionCallback = function(attribute) {
    if ($('.character-attribute-line').length === 5) {
      NotyMessage.show('Você já escolheu o máximo de atributos possíveis. Remova um ou limpe o painel do sistema de RPG para continuar.', 5000);
    } else {
      var data = this._attributeData(attribute);

      this._addAttribute(data);
      $('#remote-modal').modal('hide');
    }
  };

  fn._attributeData = function(attribute) {
    var id = parseInt($('#sheet').data('character-id')),
        character = this.game.characters.where({ id: id }),
        groupName = attribute.parents('[data-group-name]').data('group-name'),
        attributeName = attribute.data('attribute-name'),
        points = attribute.data('points') || 0,
        value = attribute.data('value') || 0,
        data = {
          "id": id,
          "avatar": character.avatar,
          "name": character.name,
          "groupName": groupName,
          "attributeName": attributeName,
          "points": points,
          "value": value
        };

    return data;
  };

  fn._addAttribute = function(data) {
    var template = $('.character-attribute-line-template').clone();

    template.removeClass('character-attribute-line-template');
    template.data('attribute-name', data.attributeName);
    template.data('character-name', data.name);
    template.data('character-id', data.id);

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

    if (this.attributes.length % 2 == 1)
      template.addClass('odd');

    if (this.attributes.length == 0) {
      $('#attributes-area').html(template);
    } else {
      $('#attributes-area').append(template);
    }

    this.attributes.push(data);
    this._attributesCount();
  };

  fn._attributesCount = function() {
    var badge = $('#rules-set-box-attributes'),
        redBadgeClass = 'red-badge';

    if (this.attributes.length > 0) {
      badge.addClass(redBadgeClass);
    } else {
      badge.removeClass(redBadgeClass);
    }

    badge.text(this.attributes.length);
  };

  fn._removeAttribute = function(e) {
    var element = $(e.currentTarget),
        line = element.parents('.character-attribute-line'),
        originalPosition = $('[data-original-position]', line).val(),
        attribute = this._findAttribute(originalPosition),
        index = this.attributes.indexOf(attribute);

    line.fadeOut();
    this.attributes.splice(index, 1);
    this._attributesCount();

    if (this.attributes.length === 0) {
      this._clear();
    }

    line.remove();
    this._recalculatePositions();
  };

  fn._clear = function() {
    this.attributes = [];
    $('#attributes-area').html('<div class="splash"><i class="fa fa-spinner fa-spin"></i> Escolha os atributos nas fichas</div>');
    $('.tests-result.on').removeClass('on');
    $('.tests-result').html('').css('background-color', 'transparent');
  };

  fn._findAttribute = function(originalPosition) {
    return $.grep(this.attributes, function (e) { return e.originalPosition == originalPosition; })[0];
  };

  fn._recalculatePositions = function() {
    var self = this,
        index = 0;

    $('#attributes-area .character-attribute-line').each(function (_, item) {
      var position = index + 1,
          originalPosition = $('[data-original-position]', item).val(),
          attribute = self._findAttribute(originalPosition);

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

  return ComposePostAttributeSelection;
});
