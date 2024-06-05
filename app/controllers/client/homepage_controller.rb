class Client::HomepageController < ClientController

  def index
    @banners = Banner.active.where("online_at <= ? AND offline_at >= ?", Time.current, Time.current).order(:sort)
    @news_tickers = NewsTicker.active.limit(5).order(:sort)
    @winners = Winner.includes(:user).published
    @items = Item.active.starting.limit(8).where("online_at <= ? AND offline_at >= ?", Time.current, Time.current)
  end
end