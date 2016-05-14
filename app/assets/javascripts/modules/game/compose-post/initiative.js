define('initiative', ['compose-post-dice-control'], function(ComposePostDiceControl) {
  function Initiative(game, callback) {
    this.game = game;
    this.callback = callback;
    this.characters = game.characters;
    this.initiativeButton = $('#initiative');
    this.diceControl = new ComposePostDiceControl();

    this._bindEvents();
  };

  var fn = Initiative.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_openInitiativePanel',
      '_addCharacter',
      '_rollInitiative',
      '_calculateButtonVisibility');

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
      self._calculateButtonVisibility();
    });

    $('#initiative-character-list').select2('val', '');
    self._calculateButtonVisibility();
  };

  fn._calculateButtonVisibility = function() {
    var characters = $('.items-container .character'),
        calculateButton = $('.calculate-initiative'),
        placeholder = $('#initiative-placeholder');

    if (characters.length > 0) {
      calculateButton.show();
      placeholder.hide();
    } else {
      calculateButton.hide();
      placeholder.show();
    }
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
        var header = '<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title">Calcular iniciativas</h4></div>',
            body =   '<div class="modal-body">' + data + '</div>'
            footer = '<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button></div>',
            template = '<div class="modal-dialog" style="width: 600px">' +
                       '  <div class="modal-content">' + header + body + footer + '</div>' +
                       '</div>';

        $('#remote-modal').html(template).modal('show');

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
      this._calculateButtonVisibility();
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
    var characters = this._characterListWithInitative(),
        template = "[dices=Iniciativas]";

    if (characters.length == 0) {
      NotyMessage.show('Escolha os personagens para calcular as iniciativas', 2000);
      return;
    }

    $.each(characters, function(index, character) {
      template += "\n" + (index + 1) + ". " + character.name + " = " + character.initiative;
      template += " [spoiler]=> " + character.log + " { rolagens: " + character.dices.join(", ") + " }[/spoiler]";
    });

    template += "[/dices]\n";

    // Track.event("Post", "Initiative", $("#character-slug").val() + " on " + gameRoomUrl() + $("#topic-slug").val());

    if (this.callback && typeof(this.callback) == 'function') {
      this.callback(template);
    }
  };

  fn._characterListWithInitative = function() {
    var characterId = 0,
        character,
        value = 0,
        signal = '',
        modifier = 0,
        characters = [],
        self = this;

    $('.items-container .character').each(function(_, element) {
      var item = $(element);

      characterId = parseInt(item.attr('data-id'));
      character = self.characters.where({ id: characterId });
      value = item.find('.action-list').val();
      signal = item.find('.signal').val();
      modifier = item.find('.modifier').val();

      characters.push(self._calculateCharacterInitiative(character, value, signal, modifier));
    });

    return this._sortCharactersByInitiative(characters);
  };

  fn._sortCharactersByInitiative = function(characters) {
    var order = this.game.system.initiative.order,
        orderedList;

    if (order === 'desc') {
      orderedList = characters.sort(function(a, b) { return b.initiative - a.initiative; });
    } else {
      orderedList = characters.sort(function(a, b) { return a.initiative - b.initiative; });
    }

    return orderedList;
  };

  fn._calculateCharacterInitiative = function(character, value, signal, modifier) {
    var formula = this.game.system.initiative.formula,
        variables = formula.match(/(\w+=>\w+)/g),
        log = formula;

    $.each(variables, function(_, match) {
      var parts = match.split('=>'),
          group = parts[0],
          attribute = parts[1],
          pattern = new RegExp(match, 'g'),
          attr = character.attribute(group, attribute),
          abbreviation = attr.abbreviation || attr.name,
          points = attr.points || 0;

      formula = formula.replace(pattern, points);
      log = log.replace(pattern, points + ' (' + abbreviation + ')');
    });

    this.diceControl.clearLog();
    formula = this.diceControl.replaceDiceVariables(formula);

    var characterContainer = $('.character[data-id=' + character.id + ']');
        penalty = parseInt(characterContainer.find('.action-list').val()),
        modifier = this._initiativeModifier(characterContainer),
        expr = Parser.parse('(' + formula + ')' + modifier),
        result = expr.evaluate(expr) + penalty;

    if (penalty != 0 || modifier.length > 0) {
      log = '(' + log + ') ' + modifier;
    }

    if (penalty > 0) {
      log += ' + ' + penalty;
    } else if (penalty < 0) {
      log += ' - ' + (penalty * -1);
    }

    var diceLog = this.diceControl.stash;
    this.diceControl.clearLog();

    return {
      'id': character.id,
      'name': character.name,
      'initiative': parseInt(result),
      'log': log,
      'dices': diceLog
    };
  };

  fn._initiativeModifier = function(container) {
    var signal = container.find('.signal').val(),
        modifier = parseInt(container.find('.modifier').val());

    if (this._invalidModifierCombination(signal, modifier)) {
      return '';
    } else {
      return signal + ' ' + modifier;
    }
  };

  fn._invalidModifierCombination = function(signal, modifier) {
    if ((signal === '+' || signal === '-') && modifier === 0) {
      return true;
    } else if ((signal === '*' || signal === '/') && modifier === 1) {
      return true;
    } else if (signal == '/' && modifier == 0) {
      return true;
    } else {
      return false;
    }
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
