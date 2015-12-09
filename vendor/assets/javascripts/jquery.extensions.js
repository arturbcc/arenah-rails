(function($) {
  // Proxy a number of an object's methods to that object. Remaining arguments
  // are the method names to be bound. Useful for ensuring that all callbacks
  // defined on an object belong to it.
  //
  // Example:
  //
  //  $.proxyAll(this, 'handler1', 'handler2', ...);
  $.proxyAll = function(obj) {
    var i, length = arguments.length, key;
    if (length <= 1) throw new Error('proxyAll must be passed function names');
    for (i = 1; i < length; i++) {
      key = arguments[i];
      obj[key] = $.proxy(obj[key], obj);
    }
    return obj;
  };
})(window.jQuery);
