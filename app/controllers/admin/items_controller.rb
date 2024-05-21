class Admin::ItemsController < AdminController
  before_action :set_item, only: [:start, :pause, :end, :cancel]

  def index
    # @users = User.where(role: :client).includes(:parent, :children).page(params[:page]).per(5)
    @items = Item.all
  end

  def start
    if @item.may_start?
      @item.start!
      flash[:notice] = 'Item started successfully'
    else
      flash[:alert] = 'Cannot start item'
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Item paused successfully'
    else
      flash[:alert] = 'Cannot pause item'
    end
    redirect_to admin_items_path
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Item ended successfully'
    else
      flash[:alert] = 'Cannot end item'
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = 'Item cancelled successfully'
    else
      flash[:alert] = 'Cannot cancel item'
    end
    redirect_to admin_items_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end