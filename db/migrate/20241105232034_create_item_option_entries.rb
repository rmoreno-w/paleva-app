class CreateItemOptionEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :item_option_entries do |t|
      t.belongs_to :itemable, polymorphic: true
      t.references :item_option_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
