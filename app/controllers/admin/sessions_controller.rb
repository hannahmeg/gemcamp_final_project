class Admin::SessionsController < Devise::SessionsController
  before_action :check_admin_role, only: :create
  layout 'admin'

  def create
    super
  end

  private

  def check_admin_role
    user = User.find_by(email: params[:admin_user][:email])
    unless user && user.admin?
      flash[:alert] = "Invalid email or role"
      redirect_to new_admin_user_session_path
    end
  end

  def after_sign_in_path(resource)
    admin_root_path
  end

end
