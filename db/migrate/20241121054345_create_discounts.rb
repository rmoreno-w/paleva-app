class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.decimal :percentage, precision: 10, scale: 2
      t.date :start_date
      t.date :end_date
      t.integer :limit_of_uses
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
