//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require jquery_ujs
//= require_tree ../../../vendor/assets/javascripts/

//= require page
//= require almond

//= require modules/on-scroll-watcher
//= require modules/home
//= require modules/noty_message
//= require modules/ga-event-tracker
//= require modules/profile/edit

//= require_tree ./pages

$(document).on('ready page:load', function() {
  page.dispatch();
});
