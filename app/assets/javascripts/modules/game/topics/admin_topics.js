define('admin-topics', ['groups-controller', 'topics-controller'],
  function(GroupsController, TopicsController) {

  function AdminTopics(container) {
    new GroupsController(container);
    new TopicsController(container);
  };

  var fn = TopicsController.prototype;

  return AdminTopics;
});
