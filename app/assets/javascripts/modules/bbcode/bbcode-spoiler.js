// ============================================================================
// BBCode Spoiler:
//
// Hide any texts of blocks that must not be visible to the users until they
// explicitly decide to view them. For more information of how to design this
// block, check the bbcode-spoiler documentation on the stylesheets.
// ============================================================================
define('bbcode-spoiler', [], function() {
  function BBCodeSpoiler() {
    this._bindEvents();
  };

  var fn = BBCodeSpoiler.prototype;

  fn._bindEvents = function() {
    var spoilers = $('.bbcode-spoiler'),
        triggers = spoilers.find('.bbcode-spoiler__trigger');

    triggers.on('click', $.proxy(this._showSpoiler, this));
  };

  fn._showSpoiler = function() {
    var spoilerBlock = $(event.target).parents('bbcode-spoiler');
    spoilerBlock.find('.bbcode-spoiler__trigger').hide();
    spoilerBlock.find('.bbcode-spoiler__hidden-text').show();
  };

  return BBCodeSpoiler;
});
