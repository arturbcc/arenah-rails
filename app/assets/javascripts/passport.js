//= require jquery/dist/jquery.min
//= require jquery_ujs
//= require bootstrap/dist/js/bootstrap.min
//= require_tree ../../../vendor/assets/javascripts/
//= require modules/noty_message
//= require_tree ./modules/passport
//= require_tree ./pages

$(document).on('ready page:load', function() {
  page.dispatch();
});
