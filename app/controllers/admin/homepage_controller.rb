class Admin::HomepageController < AdminController
  require 'csv'

  def index
    @users = User.where(role: :client).includes(:parent, :children).page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            User.human_attribute_name(:email), User.human_attribute_name(:parent_email),
            User.human_attribute_name(:total_deposit), "Member Total Deposits",
            User.human_attribute_name(:coins), "Total Used Coins",
            User.human_attribute_name(:children_members)
          ]

          @users.each do |user|
            csv << [
              user.email, user.parent&.email, user.total_deposit,
              total_member_deposit(user), user.coins,
              user.tickets_count, user.children_members
            ]
          end
        end
        render plain: csv_string
      }
    end
  end

  private

  def total_member_deposit(user)
    User.where(parent_id: user.id).sum(:total_deposit)
  end

  helper_method :total_member_deposit
end