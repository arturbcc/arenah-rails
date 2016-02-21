// ============================================================================
// BBCode:
//
// Trigger all the behaviours related to BBCode. Here is the list of developed
// behaviours:
//
// * Spoiler: it shows a hidden block when the user clicks on a trigger.
// * Cleanup: it removes the first <br> tag on all Dices' blocks
// ============================================================================
define('bbcode', [], function() {
  var BBCodeSpoiler = require('bbcode-spoiler'),
      BBCodeCleanup = require('bbcode-cleanup');

  function BBCode() {
    new BBCodeSpoiler();
    new BBCodeCleanup();
  };

  var fn = BBCode.prototype;

  return BBCode;
});
