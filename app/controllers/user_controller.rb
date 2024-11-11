class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_if_user_has_restaurant
  before_action :verify_if_user_has_access

  private
  def verify_if_user_has_restaurant
    if user_signed_in? && !(current_user.has_restaurant?)
      redirect_to(new_restaurant_path) and return
    end
  end

  def verify_if_user_has_access
    if user_signed_in? && current_user.staff?
      restaurant = current_user.restaurant
      item_set_id = params[:id]
      
      allowed_paths = [
        root_path,
        new_restaurant_restaurant_operating_hour_path(restaurant.id),
        restaurant_restaurant_operating_hours_path(restaurant.id),
        restaurant_new_order_path(restaurant.id),
        restaurant_order_add_item_path(restaurant.id),
      ]
      allowed_paths << restaurant_item_option_set_path(restaurant.id, item_set_id) if item_set_id
      allowed_paths << restaurant_orders_path(restaurant.id) if request.method == 'POST' && request.path == restaurant_orders_path(restaurant.id)


      redirect_to root_path, alert: 'Você não tem acesso a esta página' unless allowed_paths.include? request.path
    end
  end
end