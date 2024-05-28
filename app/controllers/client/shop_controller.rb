class Client::ShopController < ClientController
  def index
    @offers = Offer.all
  end
end