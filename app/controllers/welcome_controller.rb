class WelcomeController < ApplicationController
  def index
    if user_signed_in? && !(current_user.has_restaurant?)
      redirect_to new_restaurant_path
      
    elsif user_signed_in?
      @restaurant = current_user.restaurant
    end
  end
end
