class CreateNewsTickers < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tickers do |t|
      t.string :content
      t.integer :status
      t.references :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
