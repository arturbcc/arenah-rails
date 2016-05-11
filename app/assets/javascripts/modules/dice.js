var Dice = {
  roll: function(quantity, diceType) {
    var result = 0;

    for (var i = 1; i <= quantity; i++) {
      result += Math.floor((Math.random() * diceType) + 1);
    }

    return result;
  },

  parse: function(expression) {
    var result = 0,
        parts = expression.toUpperCase().split('D');

    if (parts.length === 2) {
      var quantity = parseInt(parts[0]),
          diceType = parseInt(parts[1]);

      result = this.roll(quantity, diceType);
    }

    return result;
  }
};
