// TODO: Work on this js file. Transform it into separatedly components
function gameRoomUrl() {
  return "/" + $("#game-room").val() + "/";
}

$.fn.scrollBottom = function () {
  return $(document).height() - this.scrollTop() - this.height();
};

$.urlParam = function (name) {
  var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if (results == null) {
    return null;
  }
  else {
    return results[1] || 0;
  }
}

var PrivateMessages = {
  checkForNewMessages: function (characterSlug) {
    setTimeout(function () {
      $.get(gameRoomUrl() + "personagem/" + characterSlug + "/novas-mensagens", function (data) {
        $("#header-messages").addClass("marked-to-remove");
        $("#header-messages").before(data);
        $("#header-messages.marked-to-remove").remove();

        PrivateMessages.checkForNewMessages(characterSlug);
      });
    }, 240000);
  }
}

var PrivateAlerts = {
  checkForNewAlerts: function (characterSlug) {
    setTimeout(function () {
      $.get(gameRoomUrl() + "personagem/" + characterSlug + "/novos-alertas", function (data) {
        $("#header-alerts").addClass("marked-to-remove");
        $("#header-alerts").before(data);
        $("#header-alerts.marked-to-remove").remove();

        PrivateAlerts.checkForNewAlerts(characterSlug);
      });
    }, 300000);
  }
}

$(document).ready(function () {
  if ($(".messages-dropdown").length > 0 && $("#character-slug").length > 0) {
    var characterSlug = $("#character-slug").val();
    PrivateMessages.checkForNewMessages(characterSlug);
  }

  if ($(".alerts-dropdown").length > 0 && $("#character-slug").length > 0) {
    var characterSlug = $("#character-slug").val();
    PrivateAlerts.checkForNewAlerts(characterSlug);
  }

  $("#my-characters img").qtip({
    style: {
      classes: 'qtip-bootstrap'
    },
    position: {
      my: 'top center',
      at: 'bottom center'
    }
  });
});
