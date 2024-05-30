class Admin::HomepageController < AdminController

  def index
    @users = User.where(role: :client).includes(:parent, :children).page(params[:page]).per(5)
  end

  private

  def total_member_deposit(user)
    User.where(parent_id: user.id).sum(:total_deposit)
  end

  helper_method :total_member_deposit
end