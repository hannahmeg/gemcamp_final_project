class Admin::WinnersController < AdminController
  require 'csv'
  before_action :find_winner, except: [:index]

  def index
    @winners = Winner.all.includes([:item, :user]).page(params[:page]).per(10)
    filter_winners(params)
    @winners = @winners.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Winner.human_attribute_name(:item), User.human_attribute_name(:email),
            Winner.human_attribute_name(:state)
          ]

          @winners.each do |winner|
            csv << [
              winner.item.name, winner.user.email, winner.state
            ]
          end
        end
        render plain: csv_string
      end
    end
  end

  def claim
    if @winner.claim!
      flash[:notice] = "Claimed successfully"
    else
      flash[:notice] = "Failed to claim"
    end
    redirect_to admin_winners_path
  end

  def submit
    if @winner.submit!
      flash[:notice] = "Submitted successfully"
    else
      flash[:notice] = "Failed to submit"
    end
    redirect_to admin_winners_path
  end

  def pay
    if @winner.pay!
      @winner.update(paid_at: Time.now)
      @winner.update(admin_id: current_admin_user.id)
      flash[:notice] = "Paid successfully"
    else
      flash[:notice] = "Failed to pay"
    end
    redirect_to admin_winners_path
  end

  def ship
    if @winner.ship!
      flash[:notice] = "Shipped successfully"
    else
      flash[:notice] = "Failed to ship"
    end
    redirect_to admin_winners_path
  end

  def deliver
    if @winner.deliver!
      flash[:notice] = "Delivered successfully"
    else
      flash[:notice] = "Failed to deliver"
    end
    redirect_to admin_winners_path
  end

  def share
    if @winner.share!
      flash[:notice] = "Shared successfully"
    else
      flash[:notice] = "Failed to share"
    end
    redirect_to admin_winners_path
  end

  def publish
    if @winner.publish!
      flash[:notice] = "Published successfully"
    else
      flash[:notice] = "Failed to publish"
    end
    redirect_to admin_winners_path
  end

  def remove_publish
    if @winner.remove_publish!
      flash[:notice] = "Unpublished successfully"
    else
      flash[:notice] = "Failed to unpublish"
    end
    redirect_to admin_winners_path
  end

  private

  def find_winner
    @winner = Winner.find(params[:id])
  end

  def filter_winners(params)
    @winners = @winners.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @winners = @winners.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%") if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present? && params[:state] != 'All'
    @winners = @winners.where('created_at >= ?', params[:start_date]) if params[:start_date].present?
    @winners = @winners.where('created_at <= ?', params[:end_date]) if params[:end_date].present?
  end
end
