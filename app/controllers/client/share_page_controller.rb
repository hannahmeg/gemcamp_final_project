class Client::SharePageController < ClientController

  def index
    @winners = Winner.includes(:user).published
  end
end