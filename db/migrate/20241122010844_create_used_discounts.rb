class CreateUsedDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :used_discounts do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end
