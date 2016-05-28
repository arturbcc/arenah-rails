define('topics', ['topic-group-storage'], function(TopicGroupStorage) {
  function Topics(container) {
    this.topicGroupStorage = new TopicGroupStorage();

    this.container = $(container);
    this.topicGroups = this.container.find('.fm-first-level li');

    this._bindEvents();
    this._loadActiveGroup();
  };

  var fn = Topics.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_changeTopicGroup');

    this.topicGroups.find('[data-group-name]').on('click', this._changeTopicGroup);
  };

  fn.checkForUnreadPosts = function () {
    // note: I removed the data attribute data-last-post-id="<%= topic.post_id %>"
    // from the _topic_line.html.erb

    // var topics = this.container.find("nav[data-last-post-id]");
    //
    // topics.each(function() {
    //   var el = $(this),
    //       mostRecentPostId = parseInt(el.data('last-post-id')),
    //       url = el.find('a.animated').attr('href'),
    //       newPostsChecker = new UnreadPosts.Checker(mostRecentPostId, url);
    //
    //   if (newPostsChecker.hasUnreadPosts()) {
    //     el.find('span.title').prepend(UnreadPosts.icon);
    //   }
    // });
    //
    // this.warnAboutNewPosts();
  };

  fn.warnAboutNewPosts = function() {
    // var groups = this.container.find('div[data-topic-group-id]');
    //
    // groups.each(function() {
    //   var el = $(this);
    //
    //   if (el.find('.fa-exclamation-triangle').length > 0) {
    //     $('li[data-topic-group-id=' + el.attr('data-topic-group-id') + '] a').prepend(UnreadPosts.icon);
    //   }
    // });
  };

  fn._changeTopicGroup = function(event) {
    var el = $(event.target).parent();
    var topicGroupId = el.data('topic-group-id');

    this._underlineCurrentMenu(el);
    this._showTopics(topicGroupId);
  };

  fn._underlineCurrentMenu = function (element) {
    this.container.find('.active').removeClass('active');
    element.addClass("active");

    this.topicGroupStorage.save(element.data('topic-group-id'));
  };

  fn._showTopics = function (topicGroupId) {
    var visibleGroup = this.container.find('.subgroup-visible');

    visibleGroup.swapClasses('subgroup-visible', 'subgroup-invisible');
    this.container.find(".fm-wrapper div[data-topic-group-id='" + topicGroupId + "']").swapClasses('subgroup-invisible', 'subgroup-visible');
  };

  fn._loadActiveGroup = function() {
    var id = this.topicGroupStorage.current_id(),
        groupSelector = '.topics-groups > [data-topic-group-id=' + id + '] [data-group-name]';

    this.container.find(groupSelector).trigger('click');
  };

  return Topics;
});
