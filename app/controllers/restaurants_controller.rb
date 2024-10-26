class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :has_restaurant?

  def new
    @restaurant = Restaurant.new
    @weekdays = RestaurantOperatingHour.weekdays.each_pair.to_a.map{ |day, value| [I18n.t(day), value] }
    @statuses = RestaurantOperatingHour.statuses.each_pair.to_a.map{ |day, value| [I18n.t(day), value] }

    @restaurant.restaurant_operating_hours.build
  end

  def create
    # operating_hours_params, restaurant_data = get_restaurant_data_from_params
    p = get_restaurant_data_from_params
    @restaurant = Restaurant.new(p)
    @restaurant.user = current_user
    # @restaurant.save
    # puts p


    # puts operating_hours_params
    
    if @restaurant.save
      # operating_hours_params.each do |op_hour|
      #   r_op = RestaurantOperatingHour.new(op_hour)
      #   r_op.restaurant = @restaurant
      #   r_op.save
      # end
      redirect_to root_path, notice: 'Restaurante criado com sucesso!'
    else
      @weekdays = RestaurantOperatingHour.weekdays.each_pair.to_a.map{ |day, value| [I18n.t(day), value] }
      @statuses = RestaurantOperatingHour.statuses.each_pair.to_a.map{ |day, value| [I18n.t(day), value] }
      flash.now[:alert] = "Ops! Erro ao criar Restaurante #{@restaurant.errors.full_messages.to_s}"
      render "new", status: :unprocessable_entity
    end
  end

  private
  def get_restaurant_data_from_params
    # puts params.inspect
    received_params = params.require(:restaurant).permit(
      :brand_name,
      :corporate_name,
      :registration_number,
      :address,
      :phone,
      :email,
      restaurant_operating_hours_attributes: [
        :id,
        :weekday,
        :start_time,
        :end_time,
        :status
      ])

      # received_params[:restaurant_operating_hours_attributes][:weekday] = received_params[:restaurant_operating_hours_attributes][:weekday].to_i
      # received_params[:restaurant_operating_hours_attributes][:status] = received_params[:restaurant_operating_hours_attributes][:status].to_i

      # operating_hours_params = received_params.delete(:restaurant_operating_hours_attributes)

      received_params[:restaurant_operating_hours_attributes].each do |index, hours_params|
        hours_params[:weekday] = hours_params[:weekday].to_i
        hours_params[:status] = hours_params[:status].to_i
        # puts received_params
        # puts 'aq'
      end


      # puts 
      # puts received_params.as_json
      received_params
  end

  def has_restaurant?
    current_user.has_restaurant? && redirect_to(root_path)
  end
end