json.order do
  json.customer_name @order.customer_name
  json.status @order.status
  json.code @order.code
  json.date @order.created_at
  json.total @order.total
  json.discounted_total @order.is_discounted_order? ? @order.discounted_total : @order.total

  if @order.order_items.count == 0
    json.items []
  else
    json.items @order.order_items.each do |order_item|
      json.item_name order_item.item_name
      json.serving_description order_item.serving_description
      json.serving_price order_item.serving_price
      json.number_of_servings order_item.number_of_servings
      json.customer_notes order_item.customer_notes
      json.subtotal order_item.subtotal
      json.discounted_subtotal order_item.discounted_serving_price ? order_item.discounted_subtotal : order_item.subtotal
    end
  end
end
