class AddStartDateAndEndDateToItemOptionSets < ActiveRecord::Migration[7.2]
  def change
    add_column :item_option_sets, :start_date, :date
    add_column :item_option_sets, :end_date, :date
  end
end
