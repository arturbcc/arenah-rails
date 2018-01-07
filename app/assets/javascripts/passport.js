//= require jquery/dist/jquery.min
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree ../../../vendor/assets/javascripts/

//= require page
//= require almond

//= require modules/noty_message
//= require modules/ga-event-tracker
//= require_tree ./modules/passport
//= require_tree ./pages


$(document).on('ready page:load', function() {
  page.dispatch();
});
