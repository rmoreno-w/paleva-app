class Api::V1::OrdersController < Api::V1::ApiController
  def index
    @status_filter = params[:status].to_s
    valid_statuses = [ 'waiting_kitchen_approval', 'preparing', 'canceled', 'ready', 'delivered' ]
    @is_status_valid = valid_statuses.include?(@status_filter)

    if @status_filter && @is_status_valid
      @orders = @restaurant.orders.order(created_at: :asc).where(status: @status_filter)
    else
      @orders = @restaurant.orders.order(created_at: :asc).group_by { |order| order.status }
    end
  end
end
