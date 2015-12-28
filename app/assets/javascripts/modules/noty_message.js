var NotyMessage = {
  show: function (text, timeout, type) {
    type = type || 'error';
    noty({ text: text, layout: 'bottom', timeout: true, type: type, timeout: timeout });
  }
}
