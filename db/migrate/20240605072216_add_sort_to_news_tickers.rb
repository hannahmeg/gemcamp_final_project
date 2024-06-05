class AddSortToNewsTickers < ActiveRecord::Migration[7.0]
  def change
    add_column :news_tickers, :sort, :integer
  end
end
