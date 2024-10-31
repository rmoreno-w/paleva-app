class ServingsController < UserController
  before_action :get_item_and_restaurant
  def new
    @serving = Serving.new
  end

  def create
    serving_data = get_serving_params

    if params.has_key?(:dish_id)
      @serving = @dish.servings.build(serving_data)
    else
      @serving = @beverage.servings.build(serving_data)
    end

    if @serving.save
      if params.has_key?(:dish_id)
        redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Porção criada com sucesso!'
      else
        redirect_to restaurant_beverage_path(@restaurant, @beverage), notice: 'Porção criada com sucesso!'
      end
    else
      flash.now[:alert] = 'Erro ao criar Porção'
      render 'new', status: :unprocessable_entity
    end
  end

  private
  def get_item_and_restaurant
    if params.has_key?(:dish_id)
      dish_id = params[:dish_id]
      restaurant_id = params[:restaurant_id]

      @restaurant = Restaurant.find(restaurant_id)
      @dish = @restaurant.dishes.find(dish_id)
    else
      beverage_id = params[:beverage_id]
      restaurant_id = params[:restaurant_id]

      @restaurant = Restaurant.find(restaurant_id)
      @beverage = @restaurant.beverages.find(beverage_id)
    end
  end

  def get_serving_params
    params.require(:serving).permit(:description, :current_price)
  end
end