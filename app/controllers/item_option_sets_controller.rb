class ItemOptionSetsController < UserController
  before_action :get_restaurant

  def index
    # @item_option_sets = @restaurant.item_option_sets
  end
  
  def new
    @item_option_set = ItemOptionSet.new
  end

  def create
    item_option_set_params = params.require(:item_option_set).permit(:name, :start_date, :end_date)

    @item_option_set = @restaurant.item_option_sets.build
    @item_option_set.assign_attributes(item_option_set_params)

    if @item_option_set.save
      redirect_to root_path, notice: 'Cardápio criado com sucesso!'
    else
      flash.now[:alert] = 'Ops! :( Erro ao criar o Cardápio'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    set_id = params[:id]
    @item_option_set = ItemOptionSet.find(set_id)

    verify_item_set_ownership
    return if performed?

    return redirect_to root_path, alert: 'Voce não tem acesso a este cardápio' if current_user.staff? && @item_option_set.is_seasonal? && !@item_option_set.is_in_season?

    @item_option_entries = @item_option_set.active_item_option_entries
  end

  def new_dish
    set_id = params[:item_option_set_id]
    @item_option_set = ItemOptionSet.find(set_id)

    verify_item_set_ownership
    return if performed?

    restaurant_dishes = @restaurant.dishes.active
    set_dishes_ids = @item_option_set.dish_ids

    @available_dishes = restaurant_dishes.reject { |dish| set_dishes_ids.include?( dish.id )}
  end

  def add_dish
    item_set_params = params[:item_option_set_id]
    dish_id = params[:dish_id]

    @dish = Dish.find(dish_id)

    verify_dish_ownership
    return if performed?

    @item_option_set = ItemOptionSet.find(item_set_params)
    @item_option_set.item_option_entries.build(itemable: @dish)

    verify_item_set_ownership
    return if performed?

    if @item_option_set.save
      redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Prato #{@dish.name} adicionado ao Cardápio com sucesso!"
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

    verify_item_set_ownership
    return if performed?

    restaurant_beverages = @restaurant.beverages.active
    set_beverages_ids = @item_option_set.beverage_ids

    @available_beverages = restaurant_beverages.reject { |beverage| set_beverages_ids.include?( beverage.id )}
  end

  def add_beverage
    item_set_params = params[:item_option_set_id]
    beverage_id = params[:beverage_id]

    @beverage = Beverage.find(beverage_id)
    verify_beverage_ownership
    return if performed?

    @item_option_set = ItemOptionSet.find(item_set_params)
    @item_option_set.item_option_entries.build(itemable: @beverage)

    verify_item_set_ownership
    return if performed?

    if @item_option_set.save
      redirect_to restaurant_item_option_set_path(@restaurant, @item_option_set), notice: "Bebida #{@beverage.name} adicionada ao Cardápio com sucesso!"
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

    verify_item_set_ownership
    return if performed?

    @available_items = @item_option_set.item_option_entries
  end

  def delete_item
    set_id = params[:item_option_set_id]
    item_id = params[:item_id]

    @item_option_set = ItemOptionSet.find(set_id)
    verify_item_set_ownership
    return if performed?

    @item_to_remove = ItemOptionEntry.find(item_id)
    verify_item_entry_ownership
    return if performed?

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
    @restaurant = restaurant_id ? Restaurant.find(restaurant_id) : current_user.restaurant

    redirect_to root_path, alert: 'Você não tem acesso aos cardápios deste restaurante' if @restaurant.id != current_user.restaurant.id
  end

  def verify_item_set_ownership
    redirect_to root_path, alert: "Voce não tem acesso a este Cardápio" if @item_option_set.restaurant.id != current_user.restaurant.id
  end

  def verify_dish_ownership
    redirect_to root_path, alert: "Voce não tem acesso ao Prato informado" if @dish.restaurant.id != current_user.restaurant.id
  end

  def verify_beverage_ownership
    redirect_to root_path, alert: "Voce não tem acesso a Bebida informada" if @beverage.restaurant.id != current_user.restaurant.id
  end

  def verify_item_entry_ownership
    redirect_to root_path, alert: "Voce não tem acesso ao Prato/Bebida informado(a)" if @item_to_remove.itemable.restaurant.id != current_user.restaurant.id
  end
end
