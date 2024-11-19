class CreateOrderStatusChanges < ActiveRecord::Migration[7.2]
  def change
    create_table :order_status_changes do |t|
      t.references :order, null: false, foreign_key: true
      t.string :status
      t.datetime :change_time

      t.timestamps
    end
  end
end
