var SignUp = function(registerSection) {
  this.container = $(registerSection);
  this.submit = this.container.find('input[type=submit]');
  this.bindEvents();
}

var fn = SignUp.prototype;

fn.bindEvents = function() {
  var self = this;
  this.submit.on('click', function() {
    return self.validate();
  });
};

fn.validate = function() {
  var email = $('#user_email').val();
  var name = $('#user_name').val();
  var password = $('#user_password').val();
  var passwordConfirmation = $('#user_password_confirmation').val();
  var agreement = $('input[type=checkbox]').prop('checked');

  var isValid = false;
  if ($.trim(email).length == 0) {
    NotyMessage.show('Preencha o campo de e-mail', 2000);
  } else if ($.trim(name).length == 0) {
    NotyMessage.show('Escolha seu nome de usuário', 2000);
  } else if (email.indexOf('@') == -1) {
    NotyMessage.show('Forneça um e-mail válido', 2000);
  } else if ($.trim(password).length < 6) {
    NotyMessage.show('Digite uma senha com pelo menos 8 caracteres', 2000);
  } else if ($.trim(password) !== $.trim(passwordConfirmation)) {
    NotyMessage.show('A senha e a confirmação não conferem', 2000);
  } else if (!agreement) {
    NotyMessage.show('Você precisa concordar com os termos de uso antes de prosseguir com o cadastro', 3000);
  } else {
    isValid = true;
  }

  return isValid;
};
