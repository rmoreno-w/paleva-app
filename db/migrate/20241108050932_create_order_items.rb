class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.string :item_name
      t.string :serving_description
      t.decimal :serving_price
      t.integer :number_of_servings
      t.text :customer_notes
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
