class Client::ClaimController < ClientController
  before_action :set_winner

  def show
    @addresses = current_user.addresses
  end

  def update
    address_id = params[:address_id]
    if address_id.present?
      address = Address.find(address_id)
      @winner.claim!
      @winner.update(address_id: address.id)
      redirect_to winning_history_client_profile_path, notice: 'Item successfully claimed.'
    else
      redirect_to winning_history_client_profile_path, alert: 'Please select an address.'
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end
