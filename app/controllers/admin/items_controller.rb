class Admin::ItemsController < AdminController
  before_action :set_item, except: [:index, :create, :new]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to admin_items_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to admin_items_path, notice: 'Item was successfully destroyed.'
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

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_tickets, :online_at, :offline_at)
  end
end