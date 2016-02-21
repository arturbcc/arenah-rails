// FIXME: This component is not reusable. Tweak it until it is. I will need it
// on the live game page, for example.
define('players-list', [], function() {
  function PlayersList(options) {
    options = $.extend(this._defaultSettings(), options);
    this.selectedPlayerId = 0;

    this.container = $(options.container);

    this.avatars = $(options.avatar);
    this.panelHide = $(options.panelHide);
    this.panelHandle = $(options.panelHandle);
    this.panelContent = $(options.panelContent);

    this._positionElements();
    this._bindEvents();
  };

  var fn = PlayersList.prototype;

  fn._defaultSettings = function() {
    return {
      container: '#sidePanel',
      avatars: '.image-wrapper',
      panelHide: '#panelHide',
      panelHandle: '#panelHandle',
      panelContent: '#panelContent'
    };
  };

  fn._positionElements = function() {
    var windowHeight = $(window).height();
    this.panelContent.css('height', windowHeight);
    this.panelHandle.css('margin-top', (windowHeight - 190 - 35) / 2);
  };

  fn._bindEvents = function() {
    $.proxyAll(this,
      '_closeList',
      '_openList',
      '_onAvatar',
      '_outAvatar',
      '_openCharacterSheet');

    this.panelHide.on('click', this, this._closeList);
    this.panelHandle.on('click', this, this._openList);
    this.avatars.hover(this._onAvatar, this._outAvatar);
    this.avatars.on('click', this._openCharacterSheet);
  };

  fn._closeList = function() {
    var self = this;
    this.selectedPlayerId = 0;

    this.container.animate({ left: '-185px' }, 800, function() {
      self.panelHandle.fadeIn();
    });
  };

  fn._openList = function(event) {
    $(event.currentTarget).hide();

    this.selectedPlayerId = 0;
    this._startCarousel();

    this.container.stop(true, false).animate({
      'left': '0px'
    }, 700);
  };

  fn._startCarousel = function() {
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

  fn._onAvatar = function(event) {
    var element = $(event.currentTarget);
    var playerId = element.find('img').attr('rel');

    if (playerId != this.selectedPlayerId) {
      element.removeClass('player-unselected').addClass('player-over');
      this._showCharactersNames(element);
    }
  };

  fn._outAvatar = function(event) {
    var element = $(event.currentTarget);
    var playerId = element.find('img').attr('rel');

    if (playerId != this.selectedPlayerId) {
      element.removeClass('player-over').addClass('player-unselected');
      this._hideCharactersNames(element);
    }
  };

  fn._openCharacterSheet = function(event) {
    var element = $(event.currentTarget),
        retreat = this.selectedPlayerId == element.find('img').attr('rel');

    this._hideCharactersNames(this.container);
    selectedPlayerId = $(this).find('img').attr('rel');
    this.container.find('.player-selected').removeClass('player-selected').addClass('player-unselected');
    element.removeClass('player-over').removeClass('player-unselected').addClass('player-selected');
  };

  fn._showCharactersNames = function(avatar) {
    avatar.find('.character-name-background').show();
    avatar.find('.character-name').show();
  };

  fn._hideCharactersNames = function(avatar) {
    avatar.children('.character-name-background').hide();
    avatar.children('.character-name').hide();
  };

  return PlayersList;
});
