class Client::OrdersController < ClientController
  before_action :authenticate_user!

  def create
    quantity = order_params[:coins].to_i
    offer = Offer.find(params[:order][:offer_id])
    quantity.times do
      @order = Order.new(offer_id: offer.id, user_id: current_user.id)
      @order.save
    end

    if @order.save
      redirect_to client_shop_path(offer), notice: "Order(s) created successfully"
    else
      redirect_to client_shop_path(offer), alert: "Order(s) could not be created. Kindly check your balance."
    end
  end

  private

  def order_params
    params.require(:order).permit(:coins)
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "Please log in to place orders."
      redirect_to new_user_session_path
    end
  end
end

