class Admin::SessionsController < Devise::SessionsController
  before_action :check_admin_role, only: [:create]

  private

  def check_admin_role
    user = User.find_by(email: params[:user][:email])
    if user && user.admin?
      flash[:notice] = "Success"
    else
      flash[:alert] = "Invalid email or role"
      redirect_to new_admin_session_path
    end
  end

  def after_sign_in_path(resource)
    admin_root_path
  end

end
