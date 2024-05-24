class Admin::OffersController < AdminController
  before_action :set_offer, except: [:index, :create, :new]

  def index
    @offers = Offer.all
    @offers = @offers.where(status: params[:status]) if params[:status] && params[:status] != 'All'
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      redirect_to admin_offers_path, notice: 'Offer was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      redirect_to admin_offers_path, notice: 'Offer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    flash[:notice] = 'Offer destroyed successfully'
    redirect_to admin_offers_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :status, :amount, :coin)
  end
end