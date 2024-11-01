class CreatePriceRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :price_records do |t|
      t.decimal :price
      t.datetime :change_date
      t.references :serving, null: false, foreign_key: true

      t.timestamps
    end
  end
end
