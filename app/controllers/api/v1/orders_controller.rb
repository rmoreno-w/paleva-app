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

  def show
    order_code = params[:order_code]
    found_order = Order.find_by(code: order_code)

    if found_order
      return render status: :forbidden, json: { message: 'Erro - Este pedido não pertence ao restaurante informado' } if found_order.restaurant != @restaurant

      @order = found_order
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end

  def prepare
    order_code = params[:order_code]
    found_order = Order.find_by(code: order_code)

    if found_order
      return render status: :forbidden, json: { message: 'Erro - Este pedido não pertence ao restaurante informado' } if found_order.restaurant != @restaurant

      @order = found_order
      @order.preparing!
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end

  def mark_ready
    order_code = params[:order_code]
    found_order = Order.find_by(code: order_code)

    if found_order
      return render status: :forbidden, json: { message: 'Erro - Este pedido não pertence ao restaurante informado' } if found_order.restaurant != @restaurant

      @order = found_order
      @order.ready!
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end
end
