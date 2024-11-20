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
      @order.order_status_changes.create!(status: @order.status, change_time: Time.zone.now)
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
      @order.order_status_changes.create!(status: @order.status, change_time: Time.zone.now)
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end

  def deliver
    order_code = params[:order_code]
    found_order = Order.find_by(code: order_code)

    if found_order
      return render status: :forbidden, json: { message: 'Erro - Este pedido não pertence ao restaurante informado' } if found_order.restaurant != @restaurant

      @order = found_order
      @order.delivered!
      @order.order_status_changes.create!(status: @order.status, change_time: Time.zone.now)
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end

  def cancel
    order_code = params[:order_code]
    found_order = Order.find_by(code: order_code)
    annotation = params[:annotation]

    return render status: :unprocessable_entity, json: { message: 'Erro - É necessário informar uma motivação para cancelar um Pedido' } if annotation.nil? || annotation.empty?

    if found_order
      return render status: :forbidden, json: { message: 'Erro - Este pedido não pertence ao restaurante informado' } if found_order.restaurant != @restaurant

      @order = found_order
      @order.canceled!
      @status_change = @order.order_status_changes.create!(status: @order.status, change_time: Time.zone.now)
      @annotation = OrderStatusChangeAnnotation.create!(annotation: annotation, order_status_change: @status_change)
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um pedido com esse código' }
    end
  end
end
