class Client::SessionsController < Devise::SessionsController
  before_action :check_client_role, only: [:create]
  layout 'client'
  def create
    super
  end

  private

  def check_client_role
    user = User.find_by(email: params[:user][:email])
    unless user && user.client?
      flash[:alert] = "Invalid email or role"
      redirect_to new_user_session_path
    end
  end

  def after_sign_in_path(resource)
    client_root_path
  end
end
