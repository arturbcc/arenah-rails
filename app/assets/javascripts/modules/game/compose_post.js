var ComposePost = function(recipients, characters) {
  this.panels = new ComposePostPanels();

  this.recipients = recipients;
  this.characters = characters;
  this.recipientsWidth = '627px';

  this.bindEvents();
};

var fn = ComposePost.prototype;

fn.bindEvents = function() {
  $.proxyAll(this, 'autoComplete', 'selectRecipient');

  this.characters.load(this.autoComplete);
  this.recipients.onSelect(this.selectRecipient);
};

fn.autoComplete = function() {
  var panels = this.panels;

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
  .on('select2-selecting', function (e) {
    panels.showOnGroup(e.choice.id);
  })
  .on('select2-removing', function (e) {
    panels.showOnOthers(e.choice.id);
  });
};

fn.selectRecipient = function(id) {
  this.panels.showOnGroup(id);
};
