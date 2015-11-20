var Post = {
  initialize: function () {
    this.bindActions();
  },

  flipAvatarForOptions: function () {
    $('.flip-panel img').click(function () {
      var element = $(this).parents('div.flip-panel').eq(0);
      element.addClass("flip");
    });

    $('.close-flip-panel').click(function (e) {
      var element = $(this).parents('div.flip-panel').eq(0);
      console.log(element.attr("class"));
      element.removeClass("flip");
      e.preventDefault();
    });
  },

  destroy: function (id, callback) {
    var topicSlug = $("#topic-slug").val();
    var url = gameRoomUrl() + topicSlug + "/post/" + id + "/apagar";
    $.ajax({
      url: url,
      type: "POST",
      success: function (data) {
        if (data.Status != "OK") {
          NotyMessage.show("Não é possível apagar a postagem", 3000);
        } else {
          if (callback && typeof callback == "function") {
            callback(data);
          }
        }
      }
    });
  },

  bindActions: function () {
    $('#online-users').lockScrollOnFooter();
    $('.show-tooltip').tooltip();
    this.flipAvatarForOptions();

    $(".delete-post").click(function () {
      var self = this;
      if (confirm("Tem certeza que deseja excluir?")) {
        Post.destroy($(self).attr("data-post-id"), function () {
          $(self).parents(".post").fadeOut();
        });
      }
    });

    //Remove first br for each 'dices' block in the posts
    $(".dices").each(function (index, dice) { $("br", dice).eq(0).hide() });
  }
};

$(document).ready(function () {
  Post.initialize();
});