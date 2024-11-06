class ItemOptionSetsController < UserController
  before_action :get_restaurant

  def index
    @item_option_sets = @restaurant.item_option_sets
  end
  
  def new
    @item_option_set = ItemOptionSet.new
  end

  def create
    item_option_set_params = params.require(:item_option_set).permit(:name)

    @item_option_set = @restaurant.item_option_sets.build
    @item_option_set.assign_attributes(item_option_set_params)

    if @item_option_set.save
      redirect_to restaurant_item_option_sets_path, notice: 'Cardápio criado com sucesso!'
    else
      flash.now[:alert] = 'Ops! :( Erro ao criar o Cardápio'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    set_id = params[:id]
    @item_option_set = ItemOptionSet.find(set_id)
  end

  def new_dish
    set_id = params[:item_option_set_id]
    @item_option_set = ItemOptionSet.find(set_id)

    restaurant_dishes = @restaurant.dishes.active
    set_dishes_ids = @item_option_set.dish_ids

    @available_dishes = restaurant_dishes.reject { |dish| set_dishes_ids.include?( dish.id )}
  end

  def add_dish
    item_set_params = params[:item_option_set_id]
    dish_id = params[:dish_id]

    dish_to_add = Dish.find(dish_id)

    @item_option_set = ItemOptionSet.find(item_set_params)
    @item_option_set.item_option_entries.build(itemable: dish_to_add)

    if @item_option_set.save
      redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Prato #{dish_to_add.name} adicionado ao Cardápio com sucesso!"
    else
      restaurant_dishes = @restaurant.dishes.active
      set_dishes_ids = @item_option_set.dish_ids

      @available_dishes = restaurant_dishes.reject { |dish| set_dishes_ids.include?( dish.id )}
      flash.now[:alert] = 'Ops! :( Erro ao adicionar o prato ao Cardápio'
      render 'new_dish', status: :unprocessable_entity
    end
  end

  def new_beverage
    set_id = params[:item_option_set_id]
    @item_option_set = ItemOptionSet.find(set_id)

    restaurant_beverages = @restaurant.beverages.active
    set_beverages_ids = @item_option_set.beverage_ids

    @available_beverages = restaurant_beverages.reject { |beverage| set_beverages_ids.include?( beverage.id )}
  end

  def add_beverage
    item_set_params = params[:item_option_set_id]
    beverage_id = params[:beverage_id]

    beverage_to_add = Beverage.find(beverage_id)

    @item_option_set = ItemOptionSet.find(item_set_params)
    @item_option_set.item_option_entries.build(itemable: beverage_to_add)

    if @item_option_set.save
      redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Bebida #{beverage_to_add.name} adicionada ao Cardápio com sucesso!"
    else
      restaurant_beverages = @restaurant.beverages.active
      set_beverages_ids = @item_option_set.beverage_ids

      @available_beverages = restaurant_beverages.reject { |beverage| set_beverages_ids.include?( beverage.id )}
      flash.now[:alert] = 'Ops! :( Erro ao adicionar o prato ao Cardápio'
      render 'new_beverage', status: :unprocessable_entity
    end
  end

  def remove_item
    set_id = params[:item_option_set_id]
    @item_option_set = ItemOptionSet.find(set_id)

    @available_items = @item_option_set.item_option_entries
  end

  def delete_item
    set_id = params[:item_option_set_id]
    item_id = params[:item_id]

    @item_option_set = ItemOptionSet.find(set_id)
    @item_to_remove = ItemOptionEntry.find(item_id)


    if @item_to_remove.delete
      redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Item #{@item_to_remove.item_name} removido do Cardápio com sucesso!"
    else
      @available_items = @item_option_set.item_option_entries
      flash.now[:alert] = 'Ops! :( Erro ao remover o item do Cardápio'
      render 'remove_item', status: :unprocessable_entity
    end
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find(restaurant_id)

    redirect_to root_path, alert: 'Você não tem acesso aos cardápios deste restaurante' if @restaurant.id != current_user.restaurant.id
  end
end
