class AddDiscountedServingPriceToOrderItem < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :discounted_serving_price, :decimal
  end
end
