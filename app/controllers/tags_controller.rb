class TagsController < UserController
  before_action :get_restaurant
  def new
    @tag = Tag.new
  end

  def create
    tag_name = params[:tag][:name]
    @tag = Tag.new(name: tag_name, restaurant: @restaurant)

    if @tag.save
      redirect_to restaurant_dishes_path(@restaurant), notice: 'Tag criada com sucesso!'
    else
      flash.now[:alert] = 'Ops! :( Erro ao criar a Tag'
      render 'new', status: :unprocessable_entity
    end
  end

  def exclude
    @tags = @restaurant.tags
  end

  def destroy
    tag_id = params[:tag_id]
    @tag = Tag.find(tag_id)

    if @tag.destroy
      redirect_to restaurant_dishes_path(@restaurant), notice: 'Tag excluída com sucesso!'
    else
      flash.now[:alert] = 'Ops! :( Erro ao excluir a Tag'
      render 'exclude', status: :unprocessable_entity
    end
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find(restaurant_id)

    redirect_to root_path, alert: 'Ops, você não tem acesso a este restaurante' if @restaurant.id != current_user.restaurant.id
  end
end