page.at('devise/registrations#new', function() {
  var SignUp = require('sign-up');
  new SignUp('.register-section');
});
