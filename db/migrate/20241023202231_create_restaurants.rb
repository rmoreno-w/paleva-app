class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :brand_name
      t.string :corporate_name
      t.string :registration_number
      t.string :address
      t.string :phone
      t.string :email
      t.string :code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
