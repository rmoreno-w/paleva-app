class MenuSearchController < UserController
  before_action :get_restaurant

  def index
    @query = get_query_params
    dishes = @restaurant.dishes.where('name LIKE ? OR description LIKE ?', "%#{@query}%", "%#{@query}%")
    beverages = @restaurant.beverages.where('name LIKE ? OR description LIKE ?', "%#{@query}%", "%#{@query}%")
    @results = beverages + dishes
  end

  private
  def get_query_params
    params[:query]
  end

  def get_restaurant
    @restaurant = current_user.restaurant
  end
end