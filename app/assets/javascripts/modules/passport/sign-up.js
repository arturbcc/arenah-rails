define('sign-up', [], function(container) {
  function SignUp() {
    this.container = $(container);

    this._bindEvents();
  };

  var fn = SignUp.prototype;

  fn._bindEvents = function() {
    var submit = this.container.find('input[type=submit]');

    // var self = this;

    submit.on('click', $.proxy(this._validate, this));
    // submit.on('click', function() {
    //   return self._validate();
    // });
  };

  fn._validate = function() {
    var email = this.container.find('#user_email').val();
    var name = this.container.find('#user_name').val();
    var password = this.container.find('#user_password').val();
    var passwordConfirmation = this.container.find('#user_password_confirmation').val();
    var agreement = this.container.find('input[type=checkbox]').prop('checked');

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

  return SignUp;
});
