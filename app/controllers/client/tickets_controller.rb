class Client::TicketsController < ClientController
  before_action :authenticate_user!

  def create
    item = Item.find(params[:ticket][:item_id])
    quantity.times do
      @ticket = Ticket.new(item_id: item.id, user_id: current_user.id, batch_count: item.batch_count)
      @ticket.save
    end

    if @ticket.save
      redirect_to client_lottery_path(item), notice: "Ticket(s) created successfully"
    else
      redirect_to client_lottery_path(item), alert: "Ticket(s) could not be created. Kindly check your balance."
    end
  end

  private

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "Please log in to buy tickets."
      redirect_to new_user_session_path
    end
  end
end

