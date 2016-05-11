define('compose-post-dice-control', [], function() {
  function DiceControl() {
    this.diceLog = {};
    this.lastId = 0;
    this.stash = [];
  };

  var fn = DiceControl.prototype;

  fn.diceRollId = function() {
    this.lastId += 1;
    this.diceLog['dice-result-' + this.lastId] = this.stash;
    this.stash = [];

    return this.lastId;
  };

  fn.log = function(info) {
    this.stash.push(info);
  };

  fn.clearLog = function() {
    this.stash = [];
  };

  fn.showLog = function(id) {
    return this.diceLog[id].join('\n');
  };

  fn.replaceDiceVariables = function(formula) {
    var regex = new RegExp('[0-9]+[dD][0-9]+', 'g'),
        list = formula.match(regex),
        self = this;

    if (list) {
      this.clearLog();

      $.each(list, function(index, dice) {
        var diceRoll = Dice.parse(dice);
        formula = formula.replace(dice, diceRoll);
        self.log(dice + ' = ' + diceRoll);
      });
    }

    return formula;
  };

  fn.showDiceResult = function(formula, result) {
    var self = this;
    var template = $('#dice-result-item-template').clone();
    template.attr('id', 'dice-result-' + this.diceRollId());
    template.find('span').text(formula + ' = ' + result);

    template.find('i.fa-plus-circle').on('click', function() {
      $('#bbcode-editor').focus();
      $.markItUp({ replaceWith: '[dice]' + template.find('span').text() + '[/dice][clear][/clear]' });
    });

    template.find('i.fa-ellipsis-h').on('click', function() {
      $('#bbcode-editor').focus();

      var detailedLog = self.showLog(template.attr('id')),
          finalLog = $.trim(template.find('span').text());

      if (detailedLog !== finalLog) {
        if (detailedLog === '') {
          $.markItUp({ replaceWith: '[dices=Testes]' + finalLog +'[/dices]\n[clear][/clear]\n' });
        } else {
          $.markItUp({ replaceWith: '[dices=Testes]' + finalLog +'[/dices]\n[spoiler=Rolagens][dices=Rolagens]' + detailedLog + '[/dices][/spoiler][clear][/clear]\n' });
        }
      } else {
        template.find('i.fa-plus-circle').trigger('click');
      }
    });

    $('#dice-results').prepend(template);
  };

  fn.errorAlert = function () {
    NotyMessage.show('Fórmula inválida. Não foi possível realizar a rolagem de dados.', 3000);
  }

  return DiceControl;
});
