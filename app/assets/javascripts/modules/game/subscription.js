var Subscription = function(box) {
  this.container = $(box);
  this.switchButton = this.container.find('.onoffswitch-inner');

  this.bindEvents();
};

var fn = Subscription.prototype;

fn.bindEvents = function() {
  $.proxyAll(this, 'changeSwitch');

  this.switchButton.on('click', this.changeSwitch);

  $(".onoffswitch-inner").click(function () {
      var box = $(this).parents(".box");
      var isSubscribed = box.hasClass("gold-border");
      self.changeStatus(box, isSubscribed);
    });
};

fn.changeSwitch = function(event) {
  var isSubscribed = this.container.hasClass('gold-border');

  isSubscribed ? this.remove() : this.add();
};

fn.add = function() {
  var self = this;
  this.container.removeClass('normal-border').addClass('gold-border');

  $.ajax({
    url: gameRoomUrl() + "inscreva-me",
    type: 'POST',
    success: function (data) {
      if (data.Status != 'OK') {
        NotyMessage.show('Não foi possível fazer sua inscrição. Entre em contato com o mestre.', 3000);
        self.box.removeClass('gold-border').addClass('normal-border');
        $('#myonoffswitch').trigger('click');
      }
    }
  });
};

fn.remove = function() {
  var self = this;
  this.container.removeClass('gold-border').addClass('normal-border');

  $.ajax({
    url: gameRoomUrl() + 'desinscreva-me',
    type: 'POST',
    success: function (data) {
      if (data.Status != 'OK') {
        NotyMessage.show('Não foi possível remover você da sala. Entre em contato com o mestre.', 3000);
        self.box.removeClass('normal-border').addClass('gold-border');
        $('#myonoffswitch').trigger('click');
      }
    }
  });
};

/***************************/

/*var Subscription = {
  initialize: function () {
    this.bindActions();
    if ($(".box").hasClass("gold-border")) {
      this.changeSwitch();
    }
  },

  bindActions: function () {
    var self = this;
    $(".onoffswitch-inner").click(function () {
      var box = $(this).parents(".box");
      var isSubscribed = box.hasClass("gold-border");
      self.changeStatus(box, isSubscribed);
    });
  },

  subscribe: function (box) {
    var self = this;
    box.removeClass("normal-border").addClass("gold-border");
    $.ajax({
      url: gameRoomUrl() + "inscreva-me",
      type: "POST",
      success: function (data) {
        if (data.Status != "OK") {
          NotyMessage.show("Não foi possível fazer sua inscrição. Entre em contato com o mestre.", 3000);
          box.removeClass("gold-border").addClass("normal-border");
          self.changeSwitch();
        }
      }
    });
  },

  unsubscribe: function (box) {
    var self = this;
    box.removeClass("gold-border").addClass("normal-border");
    $.ajax({
      url: gameRoomUrl() + "desinscreva-me",
      type: "POST",
      success: function (data) {
        if (data.Status != "OK") {
          NotyMessage.show("Não foi possível remover você da sala. Entre em contato com o mestre.", 3000);
          box.removeClass("normal-border").addClass("gold-border");
          self.changeSwitch();
        }
      }
    });
  },

  changeStatus: function (box, isSubscribed) {
    if (isSubscribed) {
      this.unsubscribe(box);
    } else {
      this.subscribe(box);
    }
  },

  changeSwitch: function () {
    $("#myonoffswitch").trigger("click");
  }
}
*/
