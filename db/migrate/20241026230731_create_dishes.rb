class CreateDishes < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.integer :calories

      t.timestamps
    end
  end
end
