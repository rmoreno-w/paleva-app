class CreateOrderStatusChangeAnnotations < ActiveRecord::Migration[7.2]
  def change
    create_table :order_status_change_annotations do |t|
      t.references :order_status_change, null: false, foreign_key: true
      t.string :annotation

      t.timestamps
    end
  end
end
