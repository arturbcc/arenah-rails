class Game::SubscriptionController < Game::BaseController
  def show
    @area = Area.new(:inscription)

    #TODO: load subscribed only if user is logged?
    @subscribed = Subscription.where(user: @user, game: @game).present?
  end

  def create
  end

  def destroy
  end
end
