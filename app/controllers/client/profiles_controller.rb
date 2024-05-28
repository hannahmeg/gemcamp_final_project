class Client::ProfilesController < ClientController
  before_action :set_user

  def show; end

  def edit; end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to client_profile_path, notice: 'User was successfully updated.'
    else
      render :edit, notice: 'Edit was unsuccessful.'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:image, :phone_number, :username, :password, :current_password, :address, :address_region_id, :address_province_id, category_ids: [])
  end
end