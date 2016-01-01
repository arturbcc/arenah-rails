var Subscription = function(element) {
  this.container = $(element);
  this.box = this.container.find('.box');
  this.switchButton = this.container.find('.onoffswitch-inner');

  this.bindEvents();

  var isSubscribed = this.box.hasClass('gold-border');
  if (isSubscribed) {
    $('#myonoffswitch').trigger('click');
  }
};

var fn = Subscription.prototype;

fn.bindEvents = function() {
  $.proxyAll(this, 'changeSwitch');

  this.switchButton.on('click', this.changeSwitch);
};

fn.changeSwitch = function(event) {
  var isSubscribed = this.box.hasClass('gold-border');

  isSubscribed ? this.unsubscribe() : this.subscribe();
};

fn.subscribe = function() {
  var self = this,
      url = this.container.data('subscribe');

  this.box.removeClass('normal-border').addClass('gold-border');

  $.ajax({
    url: url,
    type: 'POST',
    contentType: "application/json",
    dataType: 'json',
    success: function (data) {
      if (data.status !== 'OK') {
        NotyMessage.show('Não foi possível fazer sua inscrição. Entre em contato com o mestre.', 3000);
        self.box.removeClass('gold-border').addClass('normal-border');
        $('#myonoffswitch').trigger('click');
      }
    }
  });
};

fn.unsubscribe = function() {
  var self = this,
      url = this.container.data('unsubscribe');

  this.box.removeClass('gold-border').addClass('normal-border');

  $.ajax({
    url: url,
    type: 'DELETE',
    contentType: "application/json",
    dataType: 'json',
    success: function (data) {
      if (data.status !== 'OK') {
        NotyMessage.show('Não foi possível remover você da sala. Entre em contato com o mestre.', 3000);
        self.box.removeClass('normal-border').addClass('gold-border');
        $('#myonoffswitch').trigger('click');
      }
    }
  });
};
