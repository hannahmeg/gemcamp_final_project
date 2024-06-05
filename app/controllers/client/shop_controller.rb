class Client::ShopController < ClientController
  def index
    @offers = Offer.active
    @banners = Banner.active.where("online_at <= ? AND offline_at >= ?", Time.current, Time.current).order(:sort)
    @news_tickers = NewsTicker.active.limit(5).order(:sort)
  end
end