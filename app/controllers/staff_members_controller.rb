class StaffMembersController < UserController
  before_action :get_restaurant

  def index
    @staff_members = User.staff
    @pre_registrations = PreRegistration.where(restaurant: @restaurant)
  end

  def new
    @staff_member = PreRegistration.new
  end

  def create
    pre_registration_params = params.require(:staff_member).permit(:email, :registration_number)
    @staff_member = @restaurant.pre_registrations.create(pre_registration_params)

    if @staff_member.persisted?
      redirect_to restaurant_staff_members_path(@restaurant), notice: 'Pré cadastro realizado com sucesso!'
    else
    end
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]

    @restaurant = Restaurant.find_by(id: restaurant_id)
    redirect_to root_path, alert: 'Voce não tem acesso a pedidos desse restaurante' if @restaurant != current_user.restaurant
  end
end
