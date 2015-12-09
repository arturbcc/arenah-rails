var PlayersList = function(container) {
  this.selectedPlayerId = 0;
  this.container = container || $('#sidePanel');
  this.avatars = this.container.find('.image-wrapper');
  this.panelHide = this.container.find('#panelHide');
  this.panelHandle = this.container.find('#panelHandle');
  this.panelContent = this.container.find('#panelContent');

  this.positionElements();
  this.bindEvents();
};

var fn = PlayersList.prototype;

fn.positionElements = function() {
  var windowHeight = $(window).height();
  this.panelContent.css('height', windowHeight);
  this.panelHandle.css('margin-top', (windowHeight - 190 - 35) / 2);
};

fn.bindEvents = function() {
  $.proxyAll(this, 'closeList', 'openList', 'onAvatar', 'outAvatar',
    'openCharacterSheet');

  this.panelHide.on('click', this, this.closeList);
  this.panelHandle.on('click', this, this.openList);
  this.avatars.hover(this.onAvatar, this.outAvatar);
  this.avatars.on('click', this.openCharacterSheet);
};

fn.showCharactersNames = function(avatar) {
  avatar.find('.character-name-background').show();
  avatar.find('.character-name').show();
}

fn.hideCharactersNames = function(avatar) {
  avatar.children('.character-name-background').hide();
  avatar.children('.character-name').hide();
};

fn.closeList = function() {
  var self = this;
  this.selectedPlayerId = 0;

  this.container.animate({ left: '-185px' }, 800, function() {
    self.panelHandle.fadeIn();
  });
};

fn.openList = function(event) {
  $(event.currentTarget).hide();

  this.selectedPlayerId = 0;
  this.startCarousel();

  this.container.stop(true, false).animate({
    'left': '0px'
  }, 700);
};

fn.startCarousel = function() {
  var tango = this.container.find('.jcarousel-skin-tango'),
      carousel = this.container.find('.jcarousel'),
      windowHeight = $(window).height(),
      self = this;

  carousel.jcarousel({
    vertical: true,
    auto: 0,
    scroll: 2
  });

  this.container.find('.jcarousel-container-vertical').css('height', windowHeight - 60);
  this.container.find('.jcarousel-clip-vertical').css('height', windowHeight - 140);

  carousel.mousewheel(function (event, delta) {
    var element = self.container.find('.jcarousel-next');

    if (delta > 0) {
      element = self.container.find('.jcarousel-prev');
    }

    element.trigger('click');

    return false;
  });
};

fn.onAvatar = function(event) {
  var element = $(event.currentTarget);
  var playerId = element.find('img').attr('rel');

  if (playerId != this.selectedPlayerId) {
    element.removeClass('player-unselected').addClass('player-over');
    this.showCharactersNames(element);
  }
};

fn.outAvatar = function(event) {
  var element = $(event.currentTarget);
  var playerId = element.find('img').attr('rel');

  if (playerId != this.selectedPlayerId) {
    element.removeClass('player-over').addClass('player-unselected');
    this.hideCharactersNames(element);
  }
};

fn.openCharacterSheet = function(event) {
  var element = $(event.currentTarget),
      retreat = this.selectedPlayerId == element.find('img').attr('rel');

  this.hideCharactersNames(this.container);
  selectedPlayerId = $(this).find('img').attr('rel');
  this.container.find('.player-selected').removeClass('player-selected').addClass('player-unselected');
  element.removeClass('player-over').removeClass('player-unselected').addClass('player-selected');
};
