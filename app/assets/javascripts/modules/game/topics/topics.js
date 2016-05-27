define('topics', [], function() {
  function Topics(container) {
    this.container = $(container);
    this.topicGroups = this.container.find('.fm-first-level li');

    this._bindEvents();
  };

  var fn = Topics.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_changeTopicGroup');

    this.topicGroups.find('[data-group-name]').on('click', this._changeTopicGroup);
  };

  fn.checkForUnreadPosts = function () {
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
  };

  fn._showTopics = function (topicGroupId) {
    var visibleGroup = this.container.find('.subgroup-visible');

    visibleGroup.swapClasses('subgroup-visible', 'subgroup-invisible');
    this.container.find(".fm-wrapper div[data-topic-group-id='" + topicGroupId + "']").swapClasses('subgroup-invisible', 'subgroup-visible');
  };

  return Topics;
});
