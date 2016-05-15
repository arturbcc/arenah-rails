define('damage', ['compose-post-dice-control'], function(ComposePostDiceControl) {
  function Damage(game) {
    this.game = game;
    this.damageButton = $('#damage');
    this.container = $('#damage-container');
    this.diceControl = new ComposePostDiceControl();

    this._bindEvents();
  };

  var fn = Damage.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_openDamagePanel',
      '_prepareEvents',
      '_loadAttackersList',
      '_loadVictimsList',
      '_rollDiceEvent'
    );

    this.damageButton.on('click', this._openDamagePanel);
  };

  fn._openDamagePanel = function(event) {
    this._closeAllModals();

    var button = $(event.target),
        url = button.data('url'),
        groupCharactersIds = [],
        self = this;

    $('.character-attribute-line[data-character-id]').each(function () {
      groupCharactersIds.push($(this).data('character-id'));
    });

    $.get(url, { "groupCharacters": groupCharactersIds.toString() }).done(function (data) {
      var header = '<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title">Calcular dano</h4></div>',
          body =   '<div class="modal-body">' + data + '</div>'
          footer = '<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button></div>',
          template = '<div class="modal-dialog" style="width: 600px">' +
                     '  <div class="modal-content">' + header + body + footer + '</div>' +
                     '</div>';

      $('#remote-modal').html(template).modal('show');

      self._loadAttackersList();
      self._loadVictimsList();
      self._prepareEvents();
    });
  };

  fn._closeAllModals = function() {
    $('.modal').modal('hide');
  };

  fn._prepareEvents = function() {
    var self = this,
        characterId = 0,
        character;

    $.each(this.container.find('.victim'), function() {
      var victim = $(this);
      characterId = victim.data('character-id');

      if (characterId) {
        character = this.game.characters.where({ id: characterId });

        self._fillCharacterLife(character, victim);
        self._setVictimEvents(victim.find('.close'));
      }
    });

    if ($(".items-container ul li").length > 0) {
      var itemContainer = $('.items-container');
      characterId = itemContainer.find('.character').data('id');

      if (characterId) {
        character = self.game.characters.where({ id: characterId });

        $('.items-container').find('.action-list')
          .html(self._buildAttackOptions(character))
          .off('change')
          .on('change', function() {
            $(this).parent().find('#damage-dice-expression').val($(this).val()).removeClass('error');
          })
          .trigger('change');
        $('#result-area').show();
      }
    }

    $('#damage-roll-dice').on('click', this._rollDiceEvent);

    $('.calculate-damage').on('click', function() {
      $('#bbcode-editor').focus();

      var removeLife = $('#remove-life').is(':checked');
      var victims = $('.victim[data-character-id]');

      if (victims.length > 0) {
        var damage = parseInt($('#result-panel').html()) || 1;

        var names = $.map(victims, function(item, index) {
          return self.game.characters.where({ id: $(item).data('character-id') }).name;
        });

        if (removeLife) {
          var ids = $.map(victims, function(item, index) {
            return $(item).data('character-id');
          });

          var url = $(this).data('url');
          $.post(url, { 'character_ids': ids.join(', '), 'damage': damage })
            .done(function() {
              if (names.length === 1) {
                NotyMessage.show(names.join(', ') + ' recebeu ' + damage + ' pontos de dano', 3000, 'info');
              } else {
                NotyMessage.show(names.join(', ') + ' receberam ' + damage + ' pontos de dano cada', 3000, 'info');
              }
            });
        }

        $.markItUp({ replaceWith: '[dice]Dano = ' + damage + '(' + names.join(", ") + ')[/dice]\n', placeHolder: document.getSelection() });

        // Track.event("Post", "Damage", $("#character-slug").val() + " on " + gameRoomUrl() + $("#topic-slug").val());

        NotyMessage.show('O cálculo de dano foi enviado ao post', 3000, 'success');
      } else {
        NotyMessage.show('Escolha quem receberá o dano antes de prosseguir', 3000);
      }
    });
  };

  fn._rollDiceEvent = function() {
    $('#damage-dice-expression').removeClass('error');

    var formula = $('#damage-dice-expression').val(),
        result = 0;

    try {
      var expr = Parser.parse(this.diceControl.replaceDiceVariables(formula)),
          result = expr.evaluate();

      $('#result-panel').html(result);
    }
    catch (err) {
      $('#damage-dice-expression').addClass('error');
      NotyMessage.show('Não foi possível calcular o dano, confira a fórmula e tente novamente', 3000);
    }
  };

  fn._fillCharacterLife = function(character, element) {
    // var attribute = Characters.getAttributeBySourceId(character, Sheet.data.LifeAttributesGroupId, Sheet.data.LifeSourceId);
    //
    // if (attribute) {
    //   element.find(".life-data").html("Vida:<br/> " + attribute.Points + "/" + attribute.Total);
    // }
  };

  fn._setVictimEvents = function(element) {
    element.on('click', function() {
      element.parent().remove();
    });
  };

  fn._calculate = function() {
    // $('#bbcode-editor').focus();
    //
    // var removeLife = $('#remove-life').is(':checked');
    // var victims = $('.victim[data-character-id]');
    //
    // if (victims.length > 0) {
    //   var damage = parseInt($("#result-panel").html()) || 1;
    //
    //   var names = $.map(victims, function (item, index) {
    //     return Characters.find($(item).attr("data-character-id")).Name;
    //   });
    //
    //   if (removeLife) {
    //     var ids = $.map(victims, function (item, index) {
    //       return $(item).attr("data-character-id");
    //     });
    //
    //     var topicSlug = $("#topic-slug").val();
    //     var url = gameRoomUrl() + topicSlug + "/causar-dano";
    //     $.post(url, { "characterIds": ids.join(", "), "damage": damage }).done(function () {
    //       if (names.length == 1) {
    //         NotyMessage.show(names.join(", ") + " recebeu " + damage + " pontos de dano", 3000, 'info');
    //       } else {
    //         NotyMessage.show(names.join(", ") + " receberam " + damage + " pontos de dano cada", 3000, 'info');
    //       }
    //     });
    //   }
    //
    //   $.markItUp({ replaceWith: "[dice]Dano = " + damage + "(" + names.join(", ") + ")[/dice][clear]\n", placeHolder: document.getSelection() });
    //
    //   Track.event("Post", "Damage", $("#character-slug").val() + " on " + gameRoomUrl() + $("#topic-slug").val());
    //
    //   NotyMessage.show("O cálculo de dano foi enviado ao post", 3000, 'success');
    // } else {
    //   NotyMessage.show("Escolha quem receberá o dano antes de prosseguir", 3000);
    // }
  };

  fn._loadVictimsList = function() {
    var self = this;

    $('#damage-victims').select2({
      width: '450px'
    }).on('change', function(e) {
      var id = e.val,
          character = self.game.characters.where({ id: id });

      if (character && $('.victim[data-character-id=' + id + ']').length === 0) {
        var template = $($('#victim-template').html()),
            img = template.find('img');

        img.attr('src', img.data('path').replace('AVATAR.png', character.avatar))
           .attr('title', character.name)
           .attr('alt', character.name)
           .addClass('character-avatar');

        self._fillCharacterLife(character, template);
        self._setVictimEvents(template.find('.close'));

        template.attr('data-character-id', id);
        $('#victims-list').append(template);

        $(this).select2('val', 0);
      }
    });
  };

  fn._loadAttackersList = function() {
    var self = this;

    $('#damage-character-list').select2({
      width: '450px'
    }).on('change', function(e) {
      var id = e.val,
          character = self.game.characters.where({ id: id });

      if (character) {
        var template = $($('#attacker-template').html());

        template.find('.character').attr('data-id', id);
        template.find('img.character-avatar').remove();
        var img = template.find('img.damage-avatar-template');

        img.removeClass('hidden');
        img.attr('src', img.data('path').replace('AVATAR.png', character.avatar))
            .attr('title', character.name)
            .attr('alt', character.name)
            .addClass('character-avatar');

        template.find('.action-list').html(self._buildAttackOptions(character));

        template.find('.action-list').off('change').on('change', function() {
          var element = $(this);
          element.parent().find('#damage-dice-expression').val(element.val()).removeClass('error');
        });

        template.find('.action-list').trigger('change');

        $('.items-container ul').html(template);
        $(this).select2('val', 0);
        self._rollDiceEvent();
        $('#result-area').show();
      }
    });
  };

  fn._buildAttackOptions = function(character) {
    // var self = this;
    // var itemsCount = 0;
    //
    // var equipments = "<optgroup label='Equipamentos'>";
    // $.each(character.Equipments, function (index, equipment) {
    //   if (equipment.EquippedOn == "right-hand" || equipment.EquippedOn == "left-hand") {
    //     itemsCount += 1;
    //     equipments += "<option value='" + equipment.Damage + "'>" + equipment.Name + "</option>";
    //   }
    // });
    // equipments += "</optgroup>";
    //
    // if (itemsCount == 0) {
    //   equipments = "";
    // }
    //
    // var attributesGroups = "";
    // var optGroup = "";
    // var attributeName = "";
    // var damage = "";
    // $.each(character.Sheet.AttributesGroups, function (index, attributesGroup) {
    //   optGroup = "<optgroup label='" + attributesGroup.Name + "'>";
    //   itemsCount = 0;
    //   $.each(attributesGroup.Attributes, function (index, attribute) {
    //     if (attribute.name.length > 0 && attribute.Source.AttributeType == 1) {
    //       itemsCount += 1;
    //       damage = attribute.damage;
    //
    //       if (damage == undefined) {
    //         damage = "";
    //       }
    //
    //       optGroup += "<option value='" + damage + "'>" + attribute.name + "</option>";
    //     }
    //   });
    //   optGroup += "</optgroup>";
    //
    //   if (itemsCount > 0) {
    //     attributesGroups += optGroup;
    //   }
    // });
    //
    // return "<option value='1D6'>Ação padrão</option>" + equipments + attributesGroups;
  };

  return Damage;
});
