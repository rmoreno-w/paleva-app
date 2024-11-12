if @orders.count == 0
  json.orders @orders

elsif @orders.count > 0 && @status_filter.empty? || !@is_status_valid
  json.orders do
    @orders.each do |order_status, orders_array|
      json.set! order_status do
        json.array! orders_array do |order|
          json.customer_name order.customer_name
          json.customer_phone order.customer_phone
          json.customer_email order.customer_email
          json.customer_registration_number order.customer_registration_number
          json.status order.status
          json.code order.code
        end  
      end
    end
  end

else
  json.orders @orders do |order|
    json.customer_name order.customer_name
    json.customer_phone order.customer_phone
    json.customer_email order.customer_email
    json.customer_registration_number order.customer_registration_number
    json.status order.status
    json.code order.code
  end
end
