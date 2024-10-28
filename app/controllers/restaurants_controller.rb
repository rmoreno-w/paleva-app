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
    p = get_restaurant_data_from_params
    @restaurant = Restaurant.new(p)
    @restaurant.user = current_user


    if @restaurant.save
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

    received_params[:restaurant_operating_hours_attributes].each do |index, hours_params|
      hours_params[:weekday] = hours_params[:weekday].to_i
      hours_params[:status] = hours_params[:status].to_i
    end

    received_params
  end

  def has_restaurant?
    current_user.has_restaurant? && redirect_to(root_path)
  end
end