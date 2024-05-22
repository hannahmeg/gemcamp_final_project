class Admin::TicketsController < AdminController

  def index
    @tickets = Ticket.all

    if params[:serial_number].present?
      @tickets = @tickets.where(serial_number: params[:serial_number])
    end

    if params[:item_name].present?
      @tickets = @tickets.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%")
    end

    if params[:email].present?
      @tickets = @tickets.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%")
    end

    if params[:state].present? && params[:state] != 'All'
      @tickets = @tickets.where(state: params[:state])
    end

    if params[:start_date].present?
      @tickets = @tickets.where('created_at >= ?', params[:start_date])
    end

    if params[:end_date].present?
      @tickets = @tickets.where('created_at <= ?', params[:end_date])
    end

    @tickets = @tickets.order(created_at: :desc)
  end
end
