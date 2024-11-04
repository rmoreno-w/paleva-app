class RestaurantOperatingHoursController < UserController
  def new
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
    @restaurant_operating_hour = RestaurantOperatingHour.new
    @status_options = RestaurantOperatingHour.statuses
    @weekdays = RestaurantOperatingHour.weekdays
  end

  def create
    restaurant_id = params[:restaurant_id]
    operating_hour_data = params.require(:restaurant_operating_hour).permit(:start_time, :end_time, :status, :weekday)
    operating_hour_data[:status] = operating_hour_data[:status].to_i
    operating_hour_data[:weekday] = operating_hour_data[:weekday].to_i

    @restaurant = Restaurant.find_by(id: restaurant_id)
    @restaurant_operating_hour =  RestaurantOperatingHour.new(operating_hour_data)
    @restaurant_operating_hour.restaurant = @restaurant

    if @restaurant_operating_hour.save
      redirect_to root_path, notice: "Novo horário salvo com sucesso"
    else
      flash.now[:alert] = "Erro ao criar o horário de funcionamento do restaurante, #{@restaurant_operating_hour.errors.full_messages.to_a.to_s}"
      @status_options = RestaurantOperatingHour.statuses
      @weekdays = RestaurantOperatingHour.weekdays
      render 'new', status: :unprocessable_entity
    end
  end
end