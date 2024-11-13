json.order do
  json.customer_name @order.customer_name
  json.status @order.status
  json.code @order.code
  json.date @order.created_at
  json.total @order.total

  if @order.order_items.count == 0
    json.items []
  else
    json.items @order.order_items.each do |order|
      json.item_name order.item_name
      json.serving_description order.serving_description
      json.serving_price order.serving_price
      json.number_of_servings order.number_of_servings
      json.customer_notes order.customer_notes
      json.subtotal order.subtotal
    end
  end
end

