class Client::LotteryController < ClientController
  before_action :set_item, only: [:show]

  def index
    @items = Item.active.starting.where("online_at <= ? AND offline_at >= ?", Time.current, Time.current)
    @categories = Category.all
  end

  def show
    @tickets = Ticket.where(user: current_user, item: @item, batch_count: @item.batch_count)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end