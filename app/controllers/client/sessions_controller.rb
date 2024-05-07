class Client::SessionsController < Devise::SessionsController
  before_action :check_client_role, only: [:create]

  private

  def check_client_role
    user = User.find_by(email: params[:user][:email])
    if user && user.client?
      flash[:notice] = "Success"
    else
      flash[:alert] = "Invalid email or role"
      redirect_to client_root_path
    end
  end

  def after_sign_in_path(resource)
    admin_root_path
  end

end
