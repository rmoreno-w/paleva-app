class AddNumberOfUsesToDiscount < ActiveRecord::Migration[7.2]
  def change
    add_column :discounts, :number_of_uses, :integer, default: 0
  end
end
