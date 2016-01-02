class Game::ContactController < Game::BaseController
  before_action :authenticate_user!, :set_message, :set_area

  def new
  end

  def create
    body = message_params[:body]

    if body.present?
      current_game.masters.each do |master|
        Message.create(from: current_user.id, to: master.id, body: body)
      end
      redirect_to game_new_contact_path(current_game), notice: 'Mensagem enviada com sucesso'
    else
      @message.errors.add(:body, 'a mensagem é obrigatória')
      flash[:alert] = 'Digite uma mensagem antes de prosseguir'
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def set_message
    @message = Message.new
  end

  def set_area
    @area = Area.new(:contact)
  end
end
