class DishesController < UserController
  before_action :get_restaurant
  def index
    @dishes = Dish.where(restaurant: @restaurant)
  end

  def show
    dish_id = params[:id]
    found_dish = Dish.find(dish_id)

    verify_dish_owner(found_dish)
  end

  def new
    @dish = Dish.new
  end

  def create
    @dish = @restaurant.dishes.create(get_dish_params)

    if @dish.persisted?
      redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Prato criado com sucesso'
    else
      flash.now[:alert] = "Erro ao criar o prato. #{@dish.errors.full_messages.to_s}"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    dish_id = params[:id]
    found_dish = Dish.find(dish_id)

    verify_dish_owner(found_dish)
  end

  def update
    dish_id = params[:id]
    found_dish = Dish.find(dish_id)

    verify_dish_owner(found_dish)

    if @dish.update(get_dish_params)
      redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Prato alterado com sucesso'
    else
      flash.now[:alert] = "Erro ao alterar o prato. #{@dish.errors.full_messages.to_s}"
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    dish_id = params[:id]
    found_dish = Dish.find(dish_id)

    verify_dish_owner(found_dish)

    if @dish.destroy
      redirect_to restaurant_dishes_path, notice: "Prato deletado com sucesso!"
    else
      flash.now[:alert] = "Não foi possível deletar o Prato"
      render 'show', status: :unprocessable_entity
    end
  end

  private
  def get_restaurant
    @restaurant = current_user.restaurant
  end

  def get_dish_params
    params.require(:dish).permit(:name, :description, :calories, :picture)
  end

  def verify_dish_owner(found_dish)
    if found_dish.nil? 
      return redirect_to root_path, alert: 'Ops! Prato não encontrado'
    end

    if found_dish.restaurant.id != @restaurant.id
      redirect_to root_path, alert: 'Ops! Você não tem acesso a pratos que não são do seu restaurante'
    else
        @dish = found_dish
    end
  end
end