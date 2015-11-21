var BBCode = {
  // Removes the first br for each dice block
  fixDices: function() {
    $(".dices").each(function (index, dice) {
      $("br", dice).eq(0).hide();
    });
  }
};