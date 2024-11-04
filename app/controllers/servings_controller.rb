class ServingsController < UserController
  before_action :get_item_and_restaurant
  def new
    @serving = Serving.new
  end

  def create
    serving_data = get_serving_params

    @serving = @servingable.servings.build(serving_data)

    if @serving.save
      if params.has_key?(:dish_id)
        redirect_to restaurant_dish_path(@restaurant, @servingable), notice: 'Porção criada com sucesso!'
      else
        redirect_to restaurant_beverage_path(@restaurant, @servingable), notice: 'Porção criada com sucesso!'
      end
    else
      flash.now[:alert] = 'Erro ao criar Porção'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    serving_id = params[:id]
    found_serving = Serving.find_by(id: serving_id)

    verify_serving_owner(found_serving)
  end

  def update
    serving_id = params[:id]
    found_serving = Serving.find_by(id: serving_id)
    serving_data = get_serving_params

    verify_serving_owner(found_serving)

    if @serving.update(serving_data)
      if params.has_key?(:dish_id)
        redirect_to restaurant_dish_path(@restaurant, @servingable), notice: 'Porção atualizada com sucesso!'
      else
        redirect_to restaurant_beverage_path(@restaurant, @servingable), notice: 'Porção atualizada com sucesso!'
      end
    else
      flash.now[:alert] = 'Erro ao atualizar Porção'
      render 'edit', status: :unprocessable_entity
    end
  end

  def history
    serving_id = params[:serving_id]
    found_serving = Serving.find_by(id: serving_id)

    verify_serving_owner(found_serving)
  end

  private
  def get_item_and_restaurant
    if params.has_key?(:dish_id)
      servingable_id = params[:dish_id]
      restaurant_id = params[:restaurant_id]

      @restaurant = Restaurant.find_by(id: restaurant_id)
      @servingable = Dish.find_by(id: servingable_id)
    else
      servingable_id = params[:beverage_id]
      restaurant_id = params[:restaurant_id]

      @restaurant = Restaurant.find_by(id: restaurant_id)
      @servingable = Beverage.find_by(id: servingable_id)
    end

    if @restaurant.id != @servingable.restaurant.id || @restaurant.id != current_user.restaurant.id 
      return redirect_to root_path, alert: 'Voce informou um prato ou bebida inválidos para seu restaurante'
    end
  end

  def get_serving_params
    params.require(:serving).permit(:description, :current_price)
  end

  def verify_serving_owner(found_serving)
    if found_serving.nil? 
      redirect_to root_path, alert: 'Ops! Porção não encontrada'
    end

    if found_serving.servingable.id != @servingable.id
      redirect_to root_path, alert: 'Ops! Essa porção não pertence a esse Prato/Bebida'
    end

    @serving = found_serving
  end
end