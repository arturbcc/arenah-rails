define('rules-panel-calculator', ['compose-post-dice-control'], function(ComposePostDiceControl) {
  function RulesPanelCalculator(game) {
    this.diceControl = new ComposePostDiceControl();

    this.game = game;
    this.diceRollRules = this.game.system.dice_roll_rules;

    this.template = $('#dice-result-item-template');
    this.container = $('#collapseFour');
  };

  var fn = RulesPanelCalculator.prototype;

  fn.roll = function() {
    var attributeValues = {
          'A1': this._attributeValue(0),
          'A2': this._attributeValue(1),
          'A3': this._attributeValue(2),
          'A4': this._attributeValue(3)
        },
        data = this._rollAttributesTest(attributeValues);

    if (data.error) {
      NotyMessage.show(data.error, data.delay);
      return;
    }

    var resultStats = this._resultStats(data.chance, data.result),
        template = this._buildTemplate(data, resultStats);

    $('.tests-result').html(template);

    if (resultStats) {
      $('.tests-result').css('background-color', resultStats.color);
      $('.test-result-status').html(resultStats.name);
    } else {
      $('.tests-result').addClass('on');
    }
  };

  fn._buildTemplate = function(data, resultStats) {
    var template = this.template.clone(),
        self = this;

    template.attr('id', 'dice-result-' + this.diceControl.diceRollId());
    template.find('span').text(data.dice + ' = ' + data.result + ' de ' + data.chance);

    template.find("i.fa-plus-circle").on('click', function () {
      $('#bbcode-editor').focus();
      $.markItUp({ replaceWith: '[dice]' + template.find('span').text() + '[/dice][clear][/clear]' });
    });

    template.find('i.fa-ellipsis-h').on('click', function () {
      $('#bbcode-editor').focus();

      data.formula = data.formula.toLowerCase();
      data.formula = data.formula.replace(/a1/g, self._attributeText(0));
      data.formula = data.formula.replace(/a2/g, self._attributeText(1));
      data.formula = data.formula.replace(/a3/g, self._attributeText(2));
      data.formula = data.formula.replace(/a4/g, self._attributeText(3));

      var chanceLog = 'Chance => ' + data.formula + ' = ' + data.chance,
          diceLog = 'Rolagem => ' + self.diceControl.showLog(template.attr('id')),
          resultLog = '';

      if (resultStats) {
        resultLog = 'Resultado => ' + "[color='" + resultStats.color + "']" + resultStats.name + "[/color]";
      }

      var finalLog = chanceLog + "\n" + diceLog + "\n" + resultLog;
      $.markItUp({ replaceWith: "[dices=Testes]\n" + finalLog + "[/dices][clear][/clear]" });
    });

    template.append("<div class='test-result-status'></div>");

    return template;
  };

  fn._currentRulesSet = function() {
    var name = this.container.find('.rules-set').val();

    return this._getRulesSet(name);
  };

  fn._attributeValue = function(index) {
    var attributeLine = $('.character-attribute-line').eq(index),
        value = attributeLine.find('.attribute').val(),
        firstOperator = attributeLine.find('.operator:eq(0)').val(),
        secondOperator = attributeLine.find('.operator:eq(1)').val(),
        firstModifier = parseInt(attributeLine.find('.modifier:eq(0)').val()),
        secondModifier = parseInt(attributeLine.find('.modifier:eq(1)').val()),
        formula = value +
          firstOperator + firstModifier +
          secondOperator + secondModifier;

    try {
      var expr = Parser.parse(formula);
      return expr.evaluate();
    } catch (e) {
      return 0;
    }
  };

  fn._attributeText = function(index) {
    var attributeLine = $('.character-attribute-line').eq(index);

    return '([' + attributeLine.data('character-name') + '] ' +
      attributeLine.data('attribute-name') + '(' + attributeLine.find('.attribute').val() + "))";
  },


  fn._resultStats = function(chance, result) {
    var self = this,
        rulesSet = this._currentRulesSet(),
        diceResultRules = this.game.system.dice_result_rules,
        index = 0,
        data, rule;

    while (index < diceResultRules.length && !data) {
      var resultRule = diceResultRules[index];

      if (self._evaluateResult(resultRule, chance, result)) {
        data = {
          'name': rule.name,
          'color': rule.color
        };
      }
      index += 1;
    }

    return data;
  };

  fn._evaluateResult = function(resultRule, chance, result) {
    var expression = 0,
        status = false;

    try {
      var expr = Parser.parse(resultRule.formula.toLowerCase());
      expression = expr.evaluate({ 'chance': chance });
    } catch (e) {
      console.log(e);
    }

    switch (resultRule.signal) {
      case 0:
        status = result > expression;
        break;
      case 1:
        status = result >= expression;
        break;
      case 2:
        status = result < expression;
        break;
      case 3:
        status = result <= expression;
        break;
      case 4:
        status = result == expression;
        break;
    }

    return status;
  };

  fn._rollAttributesTest = function(attributeValues) {
    var data = { "formula": "" },
        rulesSet = this._currentRulesSet(),
        test = this._getTestRule(rulesSet, $('.character-attribute-line').length);

    if (test && test.formula.length > 0) {
      data.formula = test.formula;
      data.dice = test.dice;
    }

    if (data.formula === '') {
      data.error = "Não há regra de testes para esta quantidade de atributos";
      data.delay = 3000;
    } else {
      try {
        var expr = Parser.parse(data.formula);
        data.chance = expr.evaluate(attributeValues);
        data.result = this.diceControl.replaceDiceVariables(data.dice);
      } catch (e) {
        data.error = "Não foi possível calcular os testes. Verifique se os valores estão corretos e tente novamente";
        data.delay = 3000;
      }
    }

    return data;
  };

  fn._getRulesSet = function(name) {
    return $.grep(this.diceRollRules, function(e) { return e.name === name; })[0];
  };

  fn._getTestRule = function(rulesSet, attributesCount) {
    return $.grep(rulesSet.attributes_tests, function(e) { return e.number_of_attributes == attributesCount; })[0];
  }


  return RulesPanelCalculator;
});
