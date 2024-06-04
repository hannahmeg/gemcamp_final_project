class Admin::TicketsController < AdminController
  require 'csv'

  def index
    @tickets = Ticket.all.includes([:item, :user]).page(params[:page]).per(10)
    filter_tickets(params)
    @tickets = @tickets.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            Ticket.human_attribute_name(:serial_number), Item.human_attribute_name(:name),
            User.human_attribute_name(:email), Ticket.human_attribute_name(:state),
            Ticket.human_attribute_name(:created_at)
          ]

          @tickets.each do |ticket|
            csv << [
              ticket.serial_number, ticket.item.name, ticket.user.email,
              ticket.state, ticket.created_at
            ]
          end
        end
        render plain: csv_string
      end
    end
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      @serial_number = @ticket.serial_number
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:quantity)
  end

  def filter_tickets(params)
    @tickets = @tickets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @tickets = @tickets.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name].present?
    @tickets = @tickets.joins(:user).where('LOWER(users.email) LIKE ?', "%#{params[:email].downcase}%") if params[:email].present?
    @tickets = @tickets.where(state: params[:state]) if params[:state].present? && params[:state] != 'All'
    @tickets = @tickets.where('created_at >= ?', params[:start_date]) if params[:start_date].present?
    @tickets = @tickets.where('created_at <= ?', params[:end_date]) if params[:end_date].present?
  end
end
