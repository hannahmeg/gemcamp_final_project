class Admin::InviteListController < AdminController

  def index
    @users = User.includes(:parent, :children).where.not(parent_id: nil)

    if params[:parent_email].present?
      @users = @users.where(parent_id: User.where("users.email LIKE ?", "#{params[:parent_email]}%").pluck(:id))
    end

    @users = @users.page(params[:page]).per(5)
  end
end

