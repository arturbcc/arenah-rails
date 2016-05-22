define('topics', [], function() {
  function Topics(container) {
    this.container = $(container);
    this.topicGroups = this.container.find('.fm-first-level li');
    this.topicForm = this.container.find('#topic-content-form');

    this._bindEvents();
  };

  var fn = Topics.prototype;

  fn._bindEvents = function() {
    $.proxyAll(this, '_changeTopicGroup');

    this.topicGroups.on('click', this._changeTopicGroup);
  };

  fn.checkForUnreadPosts = function () {
    var topics = this.container.find("nav[data-last-post-id]");

    topics.each(function() {
      var el = $(this),
          mostRecentPostId = parseInt(el.data('last-post-id')),
          url = el.find('a.animated').attr('href'),
          newPostsChecker = new UnreadPosts.Checker(mostRecentPostId, url);

      if (newPostsChecker.hasUnreadPosts()) {
        el.find('span.title').prepend(UnreadPosts.icon);
      }
    });

    this.warnAboutNewPosts();
  };

  fn.warnAboutNewPosts = function() {
    var groups = this.container.find('div[data-topic-group-id]');

    groups.each(function() {
      var el = $(this);

      if (el.find('.fa-exclamation-triangle').length > 0) {
        $('li[data-topic-group-id=' + el.attr('data-topic-group-id') + '] a').prepend(UnreadPosts.icon);
      }
    });
  };

  fn.initializeModal = function () {
    var subtitleContainer = this.container.find('#subtitle-container');
    $('#content-type-container input[type=radio]').on('change', function () {
      var id = $(this).val();

      if (id === 'topic') {
        subtitleContainer.show();
      } else if (id === 'category') {
        subtitleContainer.hide();
      }
    });
  };

  fn.saveContent = function () {
    if (this._validForm()) {
      this.topicForm.submit();
    }
  };

  fn._changeTopicGroup = function(event) {
    var el = $(event.target).parent();
    var topicGroupId = el.attr("data-topic-group-id");

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

  fn._validForm = function() {
    var option = this.container.find('#content-type-container input[type=radio]:checked').val(),
        title = $.trim(this.container.find('#title').val()),
        subtitle = $.trim(this.container.find('#subtitle').val()),
        valid = false;

    if (option === 'topic' && (title === '' || subtitle === '')) {
      NotyMessage.show('Todos os campos são obrigatórios', 2000);
    } else if (option === 'category' && title === '') {
      NotyMessage.show('O título é obrigatório', 2000);
    } else {
      valid = true;
    }

    return valid;
  };

  fn._reorderTopicsGroups = function() {
    var changes = {};

    $.each($('.topics-groups li'), function (index) {
      changes[$(this).attr('data-topic-group-id')] = index + 1;
    });

    $.ajax({
      url: gameRoomUrl() + 'grupos-de-topicos/reordenar',
      traditional: true,
      data: {
        'changes': JSON.stringify(changes)
      },
      type: 'POST',
      success: function (data) {
        if (data.Status !== 'OK') {
          NotyMessage.show('Não foi possível reordenar as categorias');
        }
      }
    });
  };

  return Topics;
});
