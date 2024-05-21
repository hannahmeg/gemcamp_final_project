class Client::LotteriesController < ClientController

  def show
    @items = Item.all
    @categories = Category.all
  end

end