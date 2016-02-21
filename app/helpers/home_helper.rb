# frozen_string_literal: true

module HomeHelper
  def invalid_notice?(notice)
    return true if notice.nil?

    ['Logado com sucesso.', 'Saiu com sucesso.'].include?(notice)
  end
end
