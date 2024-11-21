class DiscountsController < UserController
  before_action :get_restaurant

  def index
    @discounts = Discount.where(restaurant: @restaurant)
  end

  def show
    get_discount
  end

  def new
    @discount = Discount.new()
  end

  def create
    discount_params = get_discount_params
    @discount = Discount.new(discount_params)
    @discount.restaurant = @restaurant

    if @discount.save
      redirect_to restaurant_discounts_path(@restaurant), notice: 'Desconto criado com sucesso'
    else
      flash.now[:alert] = 'Ops! :( Erro ao criar o Desconto'
      render :new
    end
  end

  def new_dish_serving
    get_discount_param_discount_id
    return if performed?
    
    restaurant_dishes = @restaurant.dishes.active
    @available_dishes_servings = []
    
    restaurant_dishes.each do |dish|
      if dish.servings.length > 0
        @available_dishes_servings << dish.servings
      end
    end

    @available_dishes_servings = @available_dishes_servings.flatten
    @available_dishes_servings = @available_dishes_servings.map { |serving| [serving.id, serving.full_description]}

    servings_already_on_discount_ids = @discount.discounted_servings.map { |discounted_serving| discounted_serving.serving.id}
    @available_dishes_servings = @available_dishes_servings.reject { |serving_id, description| servings_already_on_discount_ids.include? serving_id } if !servings_already_on_discount_ids.empty?
  end

  def new_beverage_serving
    get_discount_param_discount_id
    return if performed?
    
    restaurant_beverages = @restaurant.beverages.active
    @available_beverages_servings = []
    
    restaurant_beverages.each do |beverage|
      if beverage.servings.length > 0
        @available_beverages_servings << beverage.servings
      end
    end

    @available_beverages_servings = @available_beverages_servings.flatten
    @available_beverages_servings = @available_beverages_servings.map { |serving| [serving.id, serving.full_description]}

    servings_already_on_discount_ids = @discount.discounted_servings.map { |discounted_serving| discounted_serving.serving.id}
    @available_beverages_servings = @available_beverages_servings.reject { |serving_id, description| servings_already_on_discount_ids.include? serving_id } if !servings_already_on_discount_ids.empty?
  end
  
  def assign
    get_discount_param_discount_id
    return if performed?
    
    serving_id = params[:serving_id]
    serving = Serving.find_by(id: serving_id)

    discounted_serving = DiscountedServing.new(discount: @discount, serving: serving)

    if discounted_serving.save
      redirect_to restaurant_discount_path(@restaurant, @discount), notice: "#{serving.servingable.name} - #{serving.description} adicionado(a) ao Desconto com sucesso!"
    else
      flash[:alert] = "Ops :( Erro ao adicionar o item ao desconto"
      if serving.servingable_type == "Dish"
        redirect_to restaurant_discount_new_dish_serving_path(@restaurant, @discount)
      else
        redirect_to restaurant_discount_new_beverage_serving_path(@restaurant, @discount)
      end
    end
  end

  private
  def get_discount_params
    params.require(:discount).permit(:name, :percentage, :start_date, :end_date, :limit_of_uses)
  end

  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find_by(id: restaurant_id)

    redirect_to root_path, alert: 'Ops, você não tem acesso a este restaurante' if current_user.restaurant.id != @restaurant.id
  end

  def get_discount
    discount_id = params[:id]
    @discount = Discount.find_by(id: discount_id)
    redirect_to root_path, alert: 'Ops, você não tem acesso a este desconto' if @discount.restaurant.id != @restaurant.id
  end

  def get_discount_param_discount_id
    discount_id = params[:discount_id]
    @discount = Discount.find_by(id: discount_id)
    redirect_to root_path, alert: 'Ops, você não tem acesso a este desconto' if @discount.restaurant.id != @restaurant.id
  end
end