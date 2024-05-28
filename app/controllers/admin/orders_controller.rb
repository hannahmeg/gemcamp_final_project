class Admin::OrdersController < AdminController
  before_action :set_order, only: [:pay, :cancel]

  def index
    @orders = Order.includes(:user, :offer)
                   .where(build_filters(params))
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)

    @subtotal_amount = @orders.sum(:amount)
    @subtotal_coins = @orders.sum(:coin)

    weekly_orders = Order.where(created_at: Time.current.beginning_of_week..Time.current.end_of_week)
    @total_amount = weekly_orders.sum(:amount)
    @total_coins = weekly_orders.sum(:coin)
  end

  def pay
    if @order.may_pay?
      @order.pay!
      flash[:notice] = 'Order paid successfully'
    else
      flash[:alert] = 'Cannot pay order'
    end
    redirect_to admin_orders_path
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = 'Order cancelled successfully'
    else
      flash[:alert] = 'Cannot cancel order'
    end
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def build_filters(params)
    filters = {}
    filters[:serial_number] = params[:serial_number] if params[:serial_number].present?
    filters[:email] = User.find_by(email: params[:email]).id if params[:email].present?
    filters[:genre] = params[:genre] if params[:genre].present?
    filters[:state] = params[:state] if params[:state].present? && params[:state] != 'All'
    filters[:offer_id] = params[:offer_id] if params[:offer_id].present?
    if params[:start_date].present? && params[:end_date].present?
      filters[:created_at] = params[:start_date].to_date.beginning_of_day..params[:end_date].to_date.end_of_day
    end
    filters
  end
end
