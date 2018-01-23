define('compose-post', ['compose-post-accordion', 'compose-post-preview', 'impersonate', 'initiative', 'damage'],
  function(ComposePostAccordion, ComposePostPreview, Impersonate, Initiative, Damage) {

  function ComposePost(game, recipients) {
    new ComposePostPreview('#preview', '#preview-modal');
    new Impersonate();
    new Initiative(game, function(initiativeText) {
      $('#bbcode-editor').focus();
      $.markItUp({ replaceWith: initiativeText });
      $('.modal').modal('hide');
    });
    new Damage(game);

    this.composePostAccordion = new ComposePostAccordion();

    this.recipients = recipients;
    this.characters = game.characters;
    this.saveButton = $('#save-post');
    this.recipientsWidth = '627px';

    this._bindEvents();
  };

  var fn = ComposePost.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, 'autoComplete', 'selectRecipient', '_onSave');

    this.characters.load(this.autoComplete);
    this.recipients.onSelect(this.selectRecipient);
    this.saveButton.on('click', this._onSave);
  };

  fn.autoComplete = function() {
    var panels = this.composePostAccordion;

    this.recipients.container.parent().show();
    this.recipients.container.select2({
      data: this.characters.pcs,
      width: this.recipientsWidth,
      multiple: true
    })
    .on('change', function(e) {
      if (e.val.length == 1 && panels.isInDicePanel()) {
        panels.closeAllPanels();
        panels.openGroupPanel();
      } else if (e.val.length == 0 && !panels.isInDicePanel()) {
        panels.openDicePanel();
      }
    })
    .on('select2-selecting', function(e) {
      panels.showOnGroup(e.choice.id);
    })
    .on('select2-removing', function(e) {
      panels.showOnOthers(e.choice.id);
    });
  };

  fn.selectRecipient = function(id) {
    this.composePostAccordion.showOnGroup(id);
  };

  fn._onSave = function(event) {
    event.preventDefault();

    var message = $('#bbcode-editor').val();

    if (message.length == 0) {
      NotyMessage.show('O post não pode ficar em branco');
    } else {
      $(event.target).parents('form').submit();
    }
  };

  return ComposePost;
});
