class Api::V1::ApiController < ActionController::API
  before_action :get_restaurant
  rescue_from StandardError, with: :error_500

  private
  def get_restaurant
    restaurant_code = params[:restaurant_code]
    found_restaurant = Restaurant.find_by(code: restaurant_code)

    if found_restaurant
      @restaurant = found_restaurant
    else
      render status: :not_found, json: { message: 'Erro - Não foi possível encontrar um restaurante com esse código' }
    end
  end

  def error_500
    render status: :internal_server_error, json: { message: 'Erro - Houve um erro interno do servidor' }
  end
end