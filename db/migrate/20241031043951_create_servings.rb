class CreateServings < ActiveRecord::Migration[7.2]
  def change
    create_table :servings do |t|
      t.decimal :current_price
      t.string :description
      t.belongs_to :servingable, polymorphic: true

      t.timestamps
    end
  end
end
