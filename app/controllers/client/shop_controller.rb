class Client::ShopController < ClientController
  before_action :set_offer, only: [:show]

  def index
    @offers = Offer.all
  end

  def show
    @orders = Order.where(user: current_user, offer: @offer)
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end