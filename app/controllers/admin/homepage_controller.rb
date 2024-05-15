class Admin::HomepageController < AdminController

  def index
    @users = User.where(role: :client).includes(:parent, :children).page(params[:page]).per(5)
  end

end