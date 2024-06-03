class Client::ShopController < ClientController
  def index
    @offers = Offer.active
    @banners = Banner.active.where("online_at <= ? AND offline_at >= ?", Time.current, Time.current)
    @news_tickers = NewsTicker.active.limit(5)
  end
end