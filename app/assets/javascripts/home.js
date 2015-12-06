//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require_tree ../../../vendor/assets/javascripts/
//= require modules/home

//= require_tree ./pages

$(document).on('ready page:load', function() {
  page.dispatch();
});
