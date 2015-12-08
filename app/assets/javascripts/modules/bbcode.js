var BBCode = {
  removeFirstBrOnDices: function() {
    $(".dices").each(function (index, dice) {
      $("br", dice).eq(0).hide();
    });
  }
};
