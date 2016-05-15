define('compose-post-attribute-selection', [], function() {
  function ComposePostAttributeSelection(game) {
    this.game = game;
    this.sheet = $('#sheet');

    this._bindEvents();
  };

  var fn = ComposePostAttributeSelection.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, 'selectionCallback');
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
    var id = parseInt(this.sheet.data('character-id')),
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

  fn._addAttribute = function() {
    // var self = this;
    // var template = $(".character-attribute-line-template").clone();
    // template.removeClass("character-attribute-line-template");
    // template.attr("data-attribute-name", data.attributeName);
    // template.attr("data-character-name", data.name);
    // template.attr("data-character-id", data.id);
    //
    // data.position = this.attributes.length + 1;
    // data.originalPosition = data.position;
    // $(".attribute-position", template).html(data.position);
    // $("[data-original-position]", template).val(data.position);
    //
    // var img = $("img", template);
    // img.attr("src", img.attr("data-path").replace("AVATAR.png", data.avatar));
    // img.attr("alt", data.name);
    // img.attr("title", data.name + " (" + data.attributeName + ")");
    // img.qtip({ style: { classes: 'qtip-tipsy' }, position: { my: 'top center', at: 'bottom center'} });
    //
    //
    // $(".attribute", template).html(
    //   "<option value='" + data.value + "'>" + data.value + " [Valor]</option> " +
    //   "<option value='" + data.points + "'>" + data.points + " [Pontos]</option> "
    // );
    //
    //
    // if (this.attributes.length % 2 == 1)
    //   template.addClass("odd");
    //
    // if (this.attributes.length == 0)
    //   $("#attributes-area").html(template);
    // else
    //   $("#attributes-area").append(template);
    //
    // this.attributes.push(data);
    // this.attributesCount();
  };

  return ComposePostAttributeSelection;
});
