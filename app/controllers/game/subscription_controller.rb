class Game::SubscriptionController < Game::BaseController
  def show
    authenticate_user!

    @area = Area.new(:inscription)
    @subscribed = Subscription.where(user: current_user, game: @game).present?
  end

  def create
    result = { status: 'Error', message: 'Usuário já inscrito' }

    if Subscription.create(user_id: current_user.id, game_id: @game.id)
      result = { status: 'OK', message: '' };

      message = "Você possui uma [b]nova inscrição[/b] na sala #{@game.name}. Para gerenciar as inscrições, acesse [url=#{master_panel_url}]o painel[/url]."
      send_message_to_masters(message)
    end

    render json: result
  end

  def destroy
    result = { status: 'Error', message: 'Usuário não inscrito' }

    if Subscription.where(user_id: current_user.id, game_id: @game.id).delete_all
      result = { status: 'OK', message: '' }
      message = "#{current_user.name} deixou a sala #{@game.name}. Para gerenciar as inscrições, acesse [url=#{master_panel_url}]o painel[/url]."
      send_message_to_masters(message)
    end

    render json: result
  end

  private

  def master_panel_url
    #TODO: Use the game master panel url in here
    'javascript:;'
  end

  def send_message_to_masters(message)
    #TODO: build messages
    # @game.masters.each do |master|
    #   Message.create!(to: master.id, message: message)
    # end
  end
end
