// TODO: Will it be like this? Check if we can componentize it
// TODO: I don't need ga tracking on localhost. Maybe this file should not exist.
var Track = {
  event: function (category, action, label) {
    if (window.ga) {
      ga('send', 'event', { eventCategory: this.environment() + category, eventAction: action, eventLabel: label });
    }
  },

  environment: function () {
    var environment = $('#environment').val();
    if (environment != '') {
      environment += '.';
    }
    return environment;
  }
}
