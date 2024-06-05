class Client::OrdersController < ClientController
  before_action :authenticate_user!

  def create
    offer = Offer.find(params[:offer_id])

    if may_order?(offer)
      @order = Order.new(offer_id: offer.id, user_id: current_user.id, genre: :deposit, amount: offer.amount, coin: offer.coin)
      if @order.save
        @order.submit!
        redirect_to client_shop_index_path, notice: "Order created successfully"
      else
        redirect_to client_shop_index_path, alert: "Order(s) could not be created. Kindly check your balance."
      end
    else
      redirect_to client_shop_index_path, alert: "Order(s) could not be created. You have reached the maximum purchase for this offer."
    end
  end

  def cancel
    @order = Order.find(params[:id])
    if @order.cancel!
      flash[:notice] = "Order cancelled successfully."
    else
      flash[:alert] = "Failed to cancel order."
    end
    redirect_to order_history_client_profile_path
  end

  private

  def may_order?(offer)
    case offer.genre
    when "one_time"
      !Order.exists?(user_id: current_user.id, offer_id: offer.id)
    when "monthly"
      !Order.exists?(user_id: current_user.id, offer_id: offer.id, created_at: 1.month.ago..Time.current)
    when "weekly"
      !Order.exists?(user_id: current_user.id, offer_id: offer.id, created_at: 1.week.ago..Time.current)
    when "daily"
      !Order.exists?(user_id: current_user.id, offer_id: offer.id, created_at: 1.day.ago..Time.current)
    else
      true
    end
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "Please log in to place orders."
      redirect_to new_user_session_path
    end
  end
end


