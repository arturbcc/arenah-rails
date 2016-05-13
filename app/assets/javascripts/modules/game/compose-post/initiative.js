define('initiative', [], function() {
  function Initiative(characters) {
    this.characters = characters;
    this.initiativeButton = $('#initiative');

    this._bindEvents();
  };

  var fn = Initiative.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_openInitiativePanel',
      '_addCharacter',
      '_rollInitiative');

    this.initiativeButton.on('click', this._openInitiativePanel);
  };

  fn._prepareEvents = function() {
    var self = this;

    $('.add-character-initiative-list').on('click', this._addCharacter);
    $('.calculate-initiative').on('click', this._rollInitiative);

    $('.items-container .action-list').each(function(index, item) {
      var characterId = parseInt($(item).parents('.character').data('id')),
          character = self.characters.where({ id: characterId }),
          content = self._buildActionSelect(character);

      $(item).html(content);
    });

    $('#initiative-container').on('click', '.close', function() {
      $(this).parents('li').remove();
    });


    $('#initiative-character-list').select2('val', '');
  };

  fn._openInitiativePanel = function(event) {
    var button = $(event.target),
        url = button.data('url'),
        groupCharactersIds = [],
        self = this;

    this._closeAllModals();

    $('#collapseOne a[data-id]').each(function(_, element) {
      var character = $(element);

      // The inline check is to fetch only the visible characters on the group.
      if (character.css('display') === 'inline') {
        groupCharactersIds.push(character.data('id'));
      }
    });

    $.get(url, { "group_characters": groupCharactersIds.join(',') })
      .done(function(data) {
        var template = '<div class="modal-dialog" style="width: 1015px"><div class="modal-content">' + data + '</div></div>';
        $('#remote-modal').html(template)
          .modal('show')
          .find('.modal-dialog').css('width', '600px');

        $('#initiative-character-list').select2({ width: '370px' });
        self._prepareEvents();
      });
  };

  fn._addCharacter = function() {
    var initiativeCharacterList = $("#initiative-character-list"),
        characterId = parseInt(initiativeCharacterList.val());

    if (!characterId) {
      NotyMessage.show('Escolha um personagem na lista.', 1500);
    } else if (this._isCharacterOnTheList(characterId)) {
      NotyMessage.show('Você já adicionou este personagem.', 1500);
    } else {
      var character = this.characters.where({ id: characterId });
      $('#initiative-container ul').append(this._parseTemplate(character));
    }
  };

  fn._isCharacterOnTheList = function(characterId) {
    $('#initiative-container .character[data-id=' + characterId + ']').length > 0;
  };

  fn._parseTemplate = function(character) {
    var template = $('.initiative-item-template').clone();
    template.find('.character').attr('data-id', character.id);
    template.find('img.characterAvatar').remove();

    //TODO: methods with lower case!
    var img = template.find('img.initiative-avatar-template');
    img.removeClass('hidden');
    img.addClass('character-avatar tiny-avatar');
    img.attr('title', character.Next)
       .attr('alt', character.Next)
       .attr('src', img.data('path').replace("AVATAR.png", character.avatar));

    $(template.find('.character-avatar')[0]).remove();
    template.find('.action-list').html(this._buildActionSelect(character));

    return template.html();
  };

  fn._closeAllModals = function() {
    $('.modal').modal('hide');
  };

  fn._rollInitiative = function () {
    // var characterId = 0,
    //     character = null,
    //     value = 0,
    //     signal = "",
    //     modifier = 0,
    //     characters = [],
    //     self = this;
    //
    // $(".items-container .character").each(function (index, item) {
    //   characterId = parseInt($(item).attr("data-id"));
    //   character = Characters.find(characterId);
    //   value = $(item).find(".action-list").val();
    //   signal = $(item).find(".signal").val();
    //   modifier = $(item).find(".modifier").val();
    //   characters.push(self.calculateCharacterInitiative(character, value, signal, modifier));
    // });
    //
    // var order = Sheet.data.InitiativeFormulaRule;
    // var orderedList = null;
    // var desc = "0";
    // var asc = "1";
    // if (order == desc) {
    //   orderedList = characters.sort(function (a, b) { return b.initiative - a.initiative; });
    // } else {
    //   orderedList = characters.sort(function (a, b) { return a.initiative - b.initiative; });
    // }
    //
    // var template = "[dices=Iniciativas]";
    // $.each(orderedList, function (index, item) {
    //   template += "\n" + (index + 1) + ". " + item.name + " = " + item.initiative;
    //   template += " [spoiler]=> " + item.log + " { rolagens: " + item.dices.join(", ") + " }[/spoiler]";
    // });
    // template += "[/dices][clear]\n";
    //
    // Track.event("Post", "Initiative", $("#character-slug").val() + " on " + gameRoomUrl() + $("#topic-slug").val());
    //
    // $('#bbcodeEditor').focus();
    // $.markItUp({ replaceWith: template });
    // $(".modal").modal("hide");
  };

  fn._calculateCharacterInitiative = function (character, value, signal, modifier) {
    // var formula = Sheet.data.InitiativeFormula;
    // var variables = formula.match(/\#\{([\w\:\s]*)\}/g);
    // var log = formula;
    //
    // $.each(variables, function (index, match) {
    //   var parts = match.substring(2, match.length - 1).split(':');
    //   var group = parts[0];
    //   var attribute = parts[1];
    //   var pattern = new RegExp(match, 'g');
    //   formula = formula.replace(pattern, Characters.attributePoints(character, group, attribute));
    //
    //   var attr = Characters.getAttribute(character, group, attribute);
    //   var abbreviation = attr.Source.Abbreviation ? attr.Source.Abbreviation : attribute;
    //   log = log.replace(pattern, Characters.attributePoints(character, group, attribute) + " (" + abbreviation + ")");
    // });
    //
    // var penalty = parseInt($(".character[data-id=" + character.Id + "]").find(".action-list").val());
    // DiceControl.clearLog();
    // formula = DiceControl.replaceDiceVariables(formula);
    // var expr = Parser.parse(formula);
    // var result = expr.evaluate(expr) + penalty;
    //
    // if (penalty > 0) {
    //   log += " + " + penalty;
    // } else if (penalty < 0) {
    //   log += " - " + (penalty * -1);
    // }
    //
    // var diceLog = DiceControl._stash
    // DiceControl.clearLog();
    //
    // return {
    //   "id": character.Id,
    //   "name": character.Name,
    //   "initiative": parseInt(result),
    //   "log": log,
    //   "dices": diceLog
    // };
  };

  fn._buildActionSelect = function(character) {
    var equipments = this._buildEquipmentOptGroup(character),
        attributesGroups = this._buildAttributesOptGroup(character);

    return "<option value='0'>Ação padrão</option>" + equipments + attributesGroups;
  };

  fn._buildEquipmentOptGroup = function(character) {
    var equipments = "<optgroup label='Equipamentos'>",
    itemsCount = 0;

    $.each(this._characterEquipments(character), function(index, equipment) {
      // if (equipment.equipped_on !== 'right-hand' || equipment.equipped_on === 'left-hand') {
      if (equipment.equipped_on) {
        itemsCount += 1;
        equipments += "<option value='" + equipment.initiative + "'>" + equipment.name + "</option>";
      }
    });
    equipments += '</optgroup>';

    if (itemsCount === 0) {
      equipments = '';
    }

    return equipments;
  };

  fn._buildAttributesOptGroup = function(character) {
    var attributesGroups = '',
        optGroup, itemsCount;

    $.each(character.sheet.attributes_groups, function(index, attributesGroup) {
      if (!attributesGroup.character_attributes) {
        return true;
      }

      optGroup = "<optgroup label='" + attributesGroup.name + "'>";
      itemsCount = 0;

      $.each(attributesGroup.character_attributes, function(index, attribute) {
        //TODO: How to know if it is attack or defense?
        if (attribute.name && attribute.name.length > 0) { // && attribute.Source.AttributeType > 0) {
          itemsCount += 1;
          optGroup += "<option value='0'>" + attribute.name + "</option>";
        }
      });
      optGroup += "</optgroup>";

      if (itemsCount > 0) {
        attributesGroups += optGroup;
      }
    });

    return attributesGroups;
  };

  fn._characterEquipments = function(character) {
    var equipments = [];

    var equipmentGroups = $.grep(character.sheet.attributes_groups, function(group) {
      return group['type'] == 'equipments';
    });

    $.each(equipmentGroups, function(_, group) {
      $.each(group.equipments, function(_, equipment) {
        equipments.push(equipment);
      });
    });

    return equipments;
  };

  return Initiative;
});
