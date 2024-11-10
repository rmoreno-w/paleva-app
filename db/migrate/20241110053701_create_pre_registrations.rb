class CreatePreRegistrations < ActiveRecord::Migration[7.2]
  def change
    create_table :pre_registrations do |t|
      t.string :email
      t.string :registration_number
      t.integer :status
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
