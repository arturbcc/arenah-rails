var EditUserProfile = {
  initialize: function () {
    var options = {
      common: {
        minChar: 1,
        usernameField: '#name'
      },
      ui: {
        showErrors: true
      },
      onKeyUp: function (evt) {
        $(evt.target).pwstrength('outputErrorList');
      }
    };

    $('#new-password').pwstrength(options);
  },

  clearFields: function() {
    $('#current-password').val('');
    $('#new-password').val('');
    $('#password-confirmation').val('');
    $('.error-list').html('');
    $('.password-verdict').html('');
  },

  validate: function () {
    var name = $.trim($('#name').val());
    var currentPassword = $.trim($('#current-password').val());
    var newPassword = $.trim($('#new-password').val());
    var passwordConfirmation = $.trim($('#password-confirmation').val());

    var isValid = false;
    if (name.length == 0) {
      NotyMessage.show('Escolha um nome de usuário', 2000);
    } else if (currentPassword.length > 0) {
      if (newPassword.length == 0) {
        NotyMessage.show('A nova senha não pode ser vazia', 2000);
      } else if (passwordConfirmation != newPassword) {
        NotyMessage.show('A nova senha e a confirmação precisam ser idênticas', 2000);
      } else {
        isValid = true;
      }
    } else {
      isValid = true;
    }

    return isValid;
  },

  save: function () {
    var isValid = this.validate(),
        self = this;

    if (isValid) {
      var name = $.trim($('#name').val()),
          userId = $.trim($('#user-id').val()),
          currentPassword = $.trim($('#current-password').val()),
          newPassword = $.trim($('#new-password').val()),
          passwordConfirmation = $.trim($('#password-confirmation').val());

      $.ajax({
        url: '/perfil/' + userId,
        type: 'PUT',
        data: {
          'name': name,
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': passwordConfirmation
        },
        success: function (data) {
          if (data['status'] != 200) {
            NotyMessage.show(data['message'], 3000);
          } else {
            $('a[data-toggle=modal]').text('Olá, ' + name);
            $('[data-dismiss]').trigger('click');
            self.clearFields();
            NotyMessage.show('Perfil atualizado com sucesso', 3000, 'success');
          }
        }
      });
    }

    return isValid;
  }
}
