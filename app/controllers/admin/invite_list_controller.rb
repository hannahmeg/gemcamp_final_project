class Admin::InviteListController < AdminController
  require 'csv'

  def index
    @users = User.includes(:parent, :children).where.not(parent_id: nil)

    if params[:parent_email].present?
      @users = @users.where(parent_id: User.where("users.email LIKE ?", "#{params[:parent_email]}%").pluck(:id))
    end

    @users = @users.page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            User.human_attribute_name(:parent_email), User.human_attribute_name(:email),
            User.human_attribute_name(:total_deposit), 'Members Total Deposit',
            User.human_attribute_name(:coins), User.human_attribute_name(:created_at),
            'Coins Used Count', 'Child Members'
          ]

          @users.each do |user|
            csv << [
              user.parent&.email, user.email, user.total_deposit,
              user.children.sum(:total_deposit), user.coins,
              user.created_at, user.tickets_count, user.children_members
            ]
          end
        end
        render plain: csv_string
      }
    end
  end
end

