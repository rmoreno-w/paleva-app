class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_if_user_has_restaurant

  private
  def verify_if_user_has_restaurant
    if user_signed_in? && !(current_user.has_restaurant?)
      redirect_to(new_restaurant_path) and return
    end
  end
end