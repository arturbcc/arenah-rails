define('compose-post-dice', ['compose-post-dice-control'], function(ComposePostDiceControl) {
  function ComposePostDice() {
    this.diceControl = new ComposePostDiceControl();
    this.diceExpression = $('#dice-expression');
    this.rollButton = $('#roll-dice');
    this.dice = $('.dice');

    this._bindEvents();
  };

  var fn = ComposePostDice.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_rollDice', '_onEnterKeyPress', '_onDiceClick', '_onDiceDoubleClick');

    this.diceExpression.on('keyPress', this._onEnterKeyPress);
    this.rollButton.on('click', this._rollDice);
    this.dice.on('click', this._onDiceClick);
    this.dice.on('dblclick', this._onDiceDoubleClick)
  };

  fn._onEnterKeyPress = function(e) {
    if (e.keyCode == 13) {
      this.rollButton.trigger('click');
    }
  };

  fn._rollDice = function() {
    this.diceExpression.removeClass('error');
    var formula = this.diceExpression.val();
    var result = 0;

    try {
      var expr = Parser.parse(this.diceControl.replaceDiceVariables(formula)),
          result = expr.evaluate();

      this.diceControl.showDiceResult(formula, result);
    }
    catch (err) {
      this.diceExpression.addClass('error');
      this.diceControl.errorAlert();
    }

    this.diceExpression.val('');
  };

  fn._onDiceClick = function(event) {
    var dice = $(event.target);
    this.diceExpression.val(dice.attr('data-dice')).removeClass('error');
  };

  fn._onDiceDoubleClick = function(event) {
    var dice = $(event.target);
    this.diceExpression.val(dice.attr('data-dice')).removeClass('error');
    this.rollButton.trigger('click');
  };

  return ComposePostDice;
});
