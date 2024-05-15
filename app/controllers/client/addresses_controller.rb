class Client::AddressesController < ClientController
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses.includes(:address_region, :address_province, :address_city, :address_barangay)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user

    if @address.save
      redirect_to client_addresses_path, notice: "Address added successfully."
    else
      flash.now[:alert] = 'Address creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to client_addresses_path, notice: 'Address was successfully updated.'
    else
      flash.now[:alert] = 'Address update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to client_addresses_path, notice: 'Address was successfully destroyed.'
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:genre, :contact_person, :street_address, :phone_number, :remark, :is_default, :user_id, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end
