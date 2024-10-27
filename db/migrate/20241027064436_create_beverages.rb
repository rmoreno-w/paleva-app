class CreateBeverages < ActiveRecord::Migration[7.2]
  def change
    create_table :beverages do |t|
      t.string :name
      t.text :description
      t.integer :calories
      t.boolean :is_alcoholic
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
