class Client::ShopController < ClientController
  def index
    @offers = Offer.active
  end
end