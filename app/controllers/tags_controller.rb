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
    @tag = Tag.find_by(id: tag_id)

    if @tag.destroy
      redirect_to restaurant_dishes_path(@restaurant), notice: 'Tag excluída com sucesso!'
    else
      flash.now[:alert] = 'Ops! :( Erro ao excluir a Tag'
      render 'exclude', status: :unprocessable_entity
    end
  end

  def new_assignment
    dish_id = params[:dish_id]
    @dish = Dish.find_by(id: dish_id)
    restaurant_tags = @restaurant.tags
    dish_tags = @dish.tags

    @tags = restaurant_tags - dish_tags
  end

  def assign
    dish_id = params[:dish_id]
    tag_id = params[:tag_id]
    @dish = Dish.find_by(id: dish_id)
    @tag = Tag.find_by(id: tag_id)

    verify_tag_ownership
    return if performed?

    dish_tag = DishTag.new(dish_id: @dish.id, tag_id: @tag.id)

    if dish_tag && dish_tag.save
      redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Característica adicionada com sucesso!'
    else
      @tags = @restaurant.tags
      flash.now[:alert] = 'Ops! :( Erro ao adicionar característica. Verifique se o prato já não possui essa característica'
      render 'new_assignment', status: :unprocessable_entity
    end
  end

  def remove_assignment
    dish_id = params[:dish_id]
    @dish = Dish.find_by(id: dish_id)
    @tags = @dish.tags
  end

  def unassign
    dish_id = params[:dish_id]
    tag_id = params[:tag_id]
    @dish = Dish.find_by(id: dish_id)
    @tag = Tag.find_by(id: tag_id)

    verify_tag_ownership
    return if performed?

    dish_tag = DishTag.find_by(dish_id: @dish.id, tag_id: @tag.id)
    return redirect_to root_path, alert: 'Esta Característica não está associada a este prato' if dish_tag.nil?

    if dish_tag.delete
      redirect_to restaurant_dish_path(@restaurant, @dish), notice: 'Característica removida com sucesso!'
    else
      @tags = @dish.tags
      flash.now[:alert] = 'Ops! :( Erro ao remover característica'
      render 'remove_assignment', status: :unprocessable_entity
    end
  end

  private
  def get_restaurant
    restaurant_id = params[:restaurant_id]
    @restaurant = Restaurant.find_by(id: restaurant_id)

    redirect_to root_path, alert: 'Ops, você não tem acesso a este restaurante' if @restaurant.id != current_user.restaurant.id
  end
  
  def verify_tag_ownership
    if @tag.nil? || @dish.nil?
      redirect_to root_path, alert: 'Prato ou Caracaterística não encontrado(s)'
    elsif @tag.restaurant != @restaurant
      redirect_to root_path, alert: 'Esta característica não pertence ao seu restaurante'
    elsif @dish.restaurant != @restaurant
      redirect_to root_path, alert: 'Este prato não pertence ao seu restaurante'
    end
  end
end