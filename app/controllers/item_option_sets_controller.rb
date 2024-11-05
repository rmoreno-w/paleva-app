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

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find(restaurant_id)

    redirect_to root_path, alert: 'Você não tem acesso aos cardápios deste restaurante' if @restaurant.id != current_user.restaurant.id
  end
end
