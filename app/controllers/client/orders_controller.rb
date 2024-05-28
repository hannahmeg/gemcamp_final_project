class Client::OrdersController < ClientController
  before_action :authenticate_user!

  def create
    offer = Offer.find(params[:offer_id])

    @order = Order.new(offer_id: offer.id, user_id: current_user.id, genre: :deposit, amount: offer.amount, coin: offer.coin)
    if @order.save
      @order.submit!
      redirect_to client_shop_index_path, notice: "Order created successfully"
    else
      redirect_to client_shop_index_path, alert: "Order(s) could not be created. Kindly check your balance."
    end
  end

  private

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "Please log in to place orders."
      redirect_to new_user_session_path
    end
  end
end


