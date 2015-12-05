var selectedPlayerId = 0;

function showCharacterName(elem) {
  elem.children('.character-name-background').show();
  elem.children('.character-name').show();
};

function hideCharacterName(elem) {
  if (!elem) {
    $('.character-name-background').hide();
    $('.character-name').hide();
  } else {
    elem.children('.character-name-background').hide();
    elem.children('.character-name').hide();
  }
};

function unbindEvents() {
  $('.image-wrapper').unbind('hover');
  $('.image-wrapper').unbind('click');
  $('.jcarousel').unbind('mousewheel');
};

function loadCharacter(character) {
};

$(document).ready(function () {
  var windowHeight = $(window).height();
  $('#panelContent').css('height', windowHeight);
  $('#panelHandle').css('margin-top', (windowHeight - 190 - 35) / 2);

  $('#panelHandle').click(function () {
    unbindEvents();
    selectedPlayerId = 0;
    $('#panelHandle').hide();

    //starting jcarousel
    $('.jcarousel').jcarousel({
      vertical: true,
      auto: 0,
      scroll: 2
    });

    $('.jcarousel-skin-tango .jcarousel-container-vertical').css('height', windowHeight - 60);
    $('.jcarousel-skin-tango .jcarousel-clip-vertical').css('height', windowHeight - 140);

    //Mouse over on side panel players
    $('.image-wrapper').hover(function () {
      var playerId = $(this).find('img').attr('rel');

      if (playerId != selectedPlayerId) {
        $(this).removeClass("player-unselected").addClass("player-over");
        showCharacterName($(this));
      }
    }, function () {
      var playerId = $(this).find('img').attr('rel');
      if (playerId != selectedPlayerId) {
        $(this).removeClass("player-over").addClass("player-unselected");
        hideCharacterName($(this));
      }
    });

    //opening/closure of player data
    $(".image-wrapper").click(function () {
      hideCharacterName();
      var retreat = selectedPlayerId == $(this).find('img').attr('rel');
      selectedPlayerId = $(this).find('img').attr('rel');
      $('.player-selected').removeClass("player-selected").addClass("player-unselected");
      //if (!retreat)
        $(this).removeClass("player-over").removeClass("player-unselected").addClass("player-selected");
     // else {
     //   $(this).addClass("player-over");
     //   selectedPlayerId = 0;
     // }

      //      var subPanel = $('#subPanel');
      //      if (subPanel.is(':visible') && (selectedPlayerId === 0 || retreat)) {
      //        subPanel.fadeOut();
      //        subPanel.hide();
      //        selectedPlayerId = 0;
      //      }
      //      else {
      //        if (subPanel.is(':visible')) {
      //          loadCharacter(selectedPlayerId);
      //        }
      //        else {
      //          subPanel.css('width', $(window).width() - 227).css('height', $(window).height() - 24).show().fadeIn('800');
      //          loadCharacter(selectedPlayerId);
      //        }
      //      }
    });

    $('.jcarousel').mousewheel(function (event, delta) {
      if (delta > 0) $('.jcarousel-prev').trigger('click');
      else $('.jcarousel-next').trigger('click');
      return false;
    });


    $('#sidePanel').stop(true, false).animate({
      'left': '0px'
    }, 700);
  });

  $('#panelHide').click(function () {
    selectedPlayerId = 0;
    $('#sidePanel').animate({
      left: '-185px'
    }, 800, function () {
      $('#panelHandle').fadeIn();
    });
  });
});
