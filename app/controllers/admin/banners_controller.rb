class Admin::BannersController < AdminController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = Banner.order(:sort)
  end

  def show; end

  def new
    @banner = Banner.new
  end

  def edit; end

  def create
    last_sort_number = Banner.maximum(:sort)
    new_sort_number = last_sort_number ? last_sort_number + 1 : 1
    @banner = Banner.new(banner_params.merge(sort: new_sort_number))

    if @banner.save
      redirect_to admin_banners_path, notice: 'News banner was successfully created.'
    else
      flash.now[:alert] = 'Failed to create news banner.'
      render :new
    end
  end

  def update
    if @banner.update(banner_params)
      redirect_to admin_banners_path, notice: 'News banner was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path, notice: 'News banner was successfully destroyed.'
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end


  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status, :sort)
  end
end
