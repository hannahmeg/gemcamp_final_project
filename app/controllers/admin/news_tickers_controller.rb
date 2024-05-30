class Admin::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:show, :edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.all
  end

  def show
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def edit
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.user = current_admin_user

    if @news_ticker.save
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully created.'
    else
      render :new
    end
    # render json: params
  end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admin_news_tickers_path, notice: 'News ticker was successfully destroyed.'
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end


  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end
end
