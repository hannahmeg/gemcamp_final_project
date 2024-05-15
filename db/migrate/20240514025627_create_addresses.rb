class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :genre
      t.string :contact_person
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.references :user, null: false, foreign_key: true
      t.references :address_region, null: false, foreign_key: { to_table: :address_regions }
      t.references :address_province, null: false, foreign_key: { to_table: :address_provinces }
      t.references :address_city, null: false, foreign_key: { to_table: :address_cities }
      t.references :address_barangay, null: false, foreign_key: { to_table: :address_barangays }

      t.timestamps
    end
  end
end
