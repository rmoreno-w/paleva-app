class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :has_restaurant?

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(get_restaurant_data_from_params)
    @restaurant.user = current_user
    
    if @restaurant.save
      redirect_to root_path, notice: 'Restaurante criado com sucesso!'
    else
      flash.now[:alert] = "Ops! Erro ao criar Restaurante"
      render "new", status: :unprocessable_entity
    end
  end

  private
  def get_restaurant_data_from_params
    params.require(:restaurant).permit(
      :brand_name,
      :corporate_name,
      :registration_number,
      :address,
      :phone,
      :email,
      :operating_hours)
  end

  def has_restaurant?
    current_user.has_restaurant? && redirect_to(root_path)
  end
end