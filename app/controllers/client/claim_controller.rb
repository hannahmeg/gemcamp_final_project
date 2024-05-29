class Client::ClaimController < ClientController
  def show
    @winner = Winner.find_by(user_id: current_user.id)
    @addresses = current_user.addresses
    @ticket = Ticket.find(params[:id])
  end

  def update
    @winner = Winner.find_by(user_id: current_user.id)
    address_id = params[:address_id]

    if address_id.present?
      address = Address.find(address_id)
      ticket_id = params[:ticket_id]

      @winner = Winner.find_by(user_id: current_user.id, ticket_id: ticket_id)
      if @winner
        @winner.claim!
        @winner.update(address_id: address.id)
        redirect_to winning_history_client_profile_path, notice: 'Item successfully claimed.'
      else
        redirect_to winning_history_client_profile_path, alert: 'Please select an address.'
      end
    end
  end
end
