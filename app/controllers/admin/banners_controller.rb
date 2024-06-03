class Admin::BannersController < AdminController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = Banner.all
  end

  def show; end

  def new
    @banner = Banner.new
  end

  def edit; end

  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      redirect_to admin_banners_path, notice: 'News banner was successfully created.'
    else
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
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end
end
