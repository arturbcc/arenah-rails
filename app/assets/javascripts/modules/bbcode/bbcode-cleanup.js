// ============================================================================
// BBCode Cleanup:
//
// TODO: remove this component
// This component is temporary and is responsible only to remove the first <br>
// tag from the dice block. The br must be there, but it is undesirable in some
// cases. A more robust solution MUST replace this component soon.
// ============================================================================
define('bbcode-cleanup', [], function() {
  function BBCodeCleanup() {
    this._bindEvents();
  };

  var fn = BBCodeCleanup.prototype;

  fn._bindEvents = function() {
    $('.dices').each(function(index, dice) {
      $('br', dice).eq(0).hide();
    });
  };

  return BBCodeCleanup;
});
