define('topic-group-storage', [], function() {
  function TopicGroupStorage() {
    this.key = 'last-topic-group-id';
  }

  var fn = TopicGroupStorage.prototype;

  fn.save = function(id) {
    localStorage.setItem(this.key, parseInt(id));
  };

  fn.current_id = function() {
    return localStorage.getItem(this.key);
  };

  return TopicGroupStorage;
});
