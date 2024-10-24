class CreateRestaurantOperatingHours < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurant_operating_hours do |t|
      t.time :start_time
      t.time :end_time
      t.integer :status
      t.integer :weekday
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
