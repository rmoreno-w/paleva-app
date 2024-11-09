class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_phone
      t.string :customer_email
      t.string :customer_registration_number
      t.integer :status, default: 1
      t.string :code
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
