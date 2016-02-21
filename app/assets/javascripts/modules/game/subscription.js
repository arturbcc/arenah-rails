define('subscription', [], function() {
  function Subscription(element) {
    this.container = $(element);
    this.box = this.container.find('.box');
    this.switchButton = this.container.find('.onoffswitch-inner');

    this._bindEvents();

    var isSubscribed = this.box.hasClass('gold-border');
    if (isSubscribed) {
      $('#myonoffswitch').trigger('click');
    }
  };

  var fn = Subscription.prototype;

  fn._bindEvents = function() {
    this.switchButton.on('click', $.proxy(this._changeSwitch, this));
  };

  fn._changeSwitch = function(event) {
    var isSubscribed = this.box.hasClass('gold-border');

    isSubscribed ? this._unsubscribe() : this._subscribe();
  };

  fn._subscribe = function() {
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

  fn._unsubscribe = function() {
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

  return Subscription;
});
