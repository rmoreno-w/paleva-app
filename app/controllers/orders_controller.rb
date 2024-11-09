class OrdersController < UserController
  before_action :get_restaurant
  before_action :set_order_hash, only: [ :add_item, :new ]

  def new
    @servings = session[:order].to_a.map { |serving_id, quantity| [Serving.find(serving_id.to_i), quantity] }
    calculate_total
  end

  def show
    order_id = params[:id]
    @order = Order.find_by(id: order_id)
    @number_of_items = @order.order_items.count
  end

  def index
    @orders = @restaurant.orders
  end

  def add_item
    item_id = params[:item_id]
    item_set_id = params[:item_set_id]

    @item = Serving.find_by(id: item_id)
    @item_option_set = ItemOptionSet.find_by(id: item_set_id)
    
    if session[:order].has_key? item_id
      session[:order][item_id] += 1
    else
      session[:order][item_id] = 1
    end

    calculate_number_of_items_on_order

    redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Item adicionado com sucesso ao Pedido! #{session[:total]} itens no pedido"
  end

  def create
    @servings = session[:order].to_a.map { |serving_id, quantity| [Serving.find(serving_id.to_i), quantity] }
    calculate_total


    customer_notes = params["[customer_notes]"]
    customer_name = params[:customer_name]
    customer_reg_number = params[:customer_registration_number]
    customer_phone = params[:customer_phone]
    customer_email = params[:customer_email]

    @order = @restaurant.orders.build(
      customer_name: customer_name,
      customer_phone: customer_phone,
      customer_email: customer_email,
      customer_registration_number: customer_reg_number
    )

    @order_items = []

    @servings.each do |serving, quantity|
      @order_items << OrderItem.new(
        item_name: serving.servingable.name,
        serving_description: serving.description,
        serving_price: serving.current_price,
        number_of_servings: quantity,
        customer_notes: customer_notes[serving.id.to_s],
        order: @order
      )
    end

    @order.transaction do
      @order.save!
      @order_items.each do |item|
        item.save!
      end

      session.delete :order
      session.delete :total
      return redirect_to restaurant_orders_path(@restaurant), notice: 'Pedido realizado com Sucesso!'
    end
    flash.now[:alert] =  'Erro ao realizar o Pedido'
    render 'show', status: :unprocessable_entity
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]

    @restaurant = Restaurant.find_by(id: restaurant_id)
  end

  def set_order_hash
    session[:order] ||= {}
  end

  def calculate_number_of_items_on_order
    number_of_items = 0
    session[:order].values.each { |quantity| number_of_items += quantity }
    session[:total] = number_of_items
  end

  def calculate_total
    per_serving_cost = @servings.map { |serving, quantity| serving.current_price * quantity  }
    @total = per_serving_cost.sum
  end
end