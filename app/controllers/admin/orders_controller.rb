class Admin::OrdersController < AdminController
  before_action :authenticate_admin_user!
  before_action :set_order, only: [:pay, :cancel]
  before_action :set_client, only: [:new_increase, :create_increase, :new_deduct, :create_deduct, :new_bonus, :create_bonus, :new_member_level, :create_member_level]

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

  def operate_balance; end
  def new_increase
    @order = @client.orders.increase.new
  end

  def create_increase
    @order = @client.orders.new(order_params.merge(genre: :increase))
    if @order.save
      @order.pay!
      redirect_to admin_orders_path, notice: 'Increase order was successfully created.'
    else
      render :new_increase
    end
  end

  def new_deduct
    @order = @client.orders.deduct.new
  end

  def create_deduct
    @order = @client.orders.new(order_params.merge(genre: :deduct))
    if @order.save
      if @order.may_pay?
        @order.pay!
        redirect_to admin_orders_path, notice: 'Deduct order was successfully created.'
      else
        @order.cancel!
        render :new_deduct
      end
    end
  end

  def new_bonus
    @order = @client.orders.bonus.new
  end

  def create_bonus
    @order = @client.orders.new(order_params.merge(genre: :bonus))
    if @order.save
      @order.pay!
      redirect_to admin_orders_path, notice: 'Bonus order was successfully created.'
    else
      render :new_bonus
    end
  end

  def new_member_level
    @order = @client.orders.member_level.new
  end

  def create_member_level
    @order = @client.orders.new(order_params.merge(genre: :member_level, remarks: 'Member Level Rewards'))
    if @order.save
      @order.pay!
      redirect_to admin_orders_path, notice: 'Member Level order was successfully created.'
    else
      render :new_member_level
    end
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

  def set_client
    @client = User.find(params[:client_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
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
