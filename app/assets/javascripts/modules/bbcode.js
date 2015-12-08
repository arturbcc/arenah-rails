var BBCode = function() {
  this.spoilers = $('.bbcode-spoiler');

  this.removeFirstBrOnDices();
  this.bindEvents();
};

var fn = BBCode.prototype;

fn.removeFirstBrOnDices: function() {
  $(".dices").each(function (index, dice) {
    $("br", dice).eq(0).hide();
  });
}

fn.bindEvents = function() {
  this.spoiler.on("click", "a", this.showSpoiler);
};

fn.showSpoiler = function() {
  $(this).hide().next().show();
}
