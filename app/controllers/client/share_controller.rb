class Client::ShareController < ClientController
  before_action :set_winner

  def show; end

  def update
    if @winner
      @winner.share!
      @winner.update(winner_params)
      flash[:notice] = "Item shared successfully"
    else
      flash[:alert] = "Failed to share. Please try again."
    end
    redirect_to winning_history_client_profile_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:picture, :comment)
  end
end
