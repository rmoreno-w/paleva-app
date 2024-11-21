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
end