class BeveragesController < UserController
  before_action :get_restaurant
  def index
    @beverages = Beverage.where(restaurant: @restaurant)
  end

  def show
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)

    verify_beverage_owner(found_beverage)
  end

  def new
    @beverage = Beverage.new
  end

  def create
    @beverage = @restaurant.beverages.create(get_beverage_params)

    if @beverage.persisted?
      redirect_to restaurant_beverage_path(@restaurant, @beverage), notice: 'Bebida criado com sucesso'
    else
      flash.now[:alert] = "Erro ao criar a bebida. #{@beverage.errors.full_messages.to_s}"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)

    verify_beverage_owner(found_beverage)
  end

  def update
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)

    verify_beverage_owner(found_beverage)
    return if performed?

    if @beverage.update(get_beverage_params)
      redirect_to restaurant_beverage_path(@restaurant, @beverage), notice: 'Bebida alterada com sucesso'
    else
      flash.now[:alert] = "Erro ao alterar a bebida. #{@beverage.errors.full_messages.to_s}"
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)

    verify_beverage_owner(found_beverage)
    return if performed?

    if @beverage.destroy
      redirect_to restaurant_beverages_path, notice: "Bebida deletada com sucesso!"
    else
      flash.now[:alert] = "Não foi possível deletar a Bebida"
      render 'show', status: :unprocessable_entity
    end
  end

  def deactivate
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)
    
    verify_beverage_owner(found_beverage)
    return if performed?

    if @beverage.active? && @beverage.inactive!
      flash[:notice] = 'Sucesso! Bebida desativada'
      redirect_to restaurant_beverage_path(@restaurant, @beverage)
    else
      flash.now[:notice] = 'Ocorreu um erro ao desativar a Bebida'
      render 'show', status: :unprocessable_entity
    end
  end

  def activate
    beverage_id = params[:id]
    found_beverage = Beverage.find_by(id: beverage_id)

    verify_beverage_owner(found_beverage)
    return if performed?

    if @beverage.inactive? && @beverage.active!
      flash[:notice] = 'Sucesso! Bebida ativada'
      redirect_to restaurant_beverage_path(@restaurant, @beverage)
    else
      flash.now[:notice] = 'Ocorreu um erro ao ativar a Bebida'
      render 'show', status: :unprocessable_entity
    end
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find_by(id: restaurant_id)
    return redirect_to root_path, alert: 'Você não tem acesso a este restaurante' if @restaurant.id != current_user.restaurant.id
  end

  def get_beverage_params
    adjust_is_alcoholic
    params.require(:beverage).permit(:name, :description, :calories, :is_alcoholic, :picture)
  end

  def adjust_is_alcoholic
    params[:beverage][:is_alcoholic] = false if params[:beverage][:is_alcoholic] == "0"
    params[:beverage][:is_alcoholic] = true if params[:beverage][:is_alcoholic] == "1"
  end

  def verify_beverage_owner(found_beverage)
    if found_beverage.nil? 
      return redirect_to root_path, alert: 'Ops! Bebida não encontrada'
    end

    if found_beverage.restaurant.id != @restaurant.id
      redirect_to root_path, alert: 'Ops! Você não tem acesso a bebidas que não são do seu restaurante'
    else
      @beverage = found_beverage
    end
  end
end
