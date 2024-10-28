require 'rails_helper'

describe 'User' do
  it 'creates a dish but is not authenticated' do
    dish = create_dish

    post(
      restaurant_dishes_path(dish.restaurant), 
      params: { 
        dish: { 
          name: dish.name,
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'creates a dish with success' do
    restaurant = create_restaurant_and_user
    dish = new_dish

    login_as restaurant.user

    post(
      restaurant_dishes_path(restaurant), 
      params: { 
        dish: { 
          name: dish.name,
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    dish = Dish.last
    expect(response.status).to redirect_to restaurant_dish_path(restaurant, dish)
  end

  it 'fails to creates a dish with invalid data' do
    restaurant = create_restaurant_and_user
    dish = new_dish

    login_as restaurant.user

    post(
      restaurant_dishes_path(restaurant), 
      params: { 
        dish: { 
          name: '',
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    expect(response.status).to eq 422
  end

  it 'deletes a dish but is not authenticated' do
    dish = create_dish

    delete(restaurant_dish_path(dish.restaurant, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a dish but is not authenticated' do
    dish = create_dish

    patch(
      restaurant_dish_path(dish.restaurant.id, dish.id), 
      params: { 
        dish: { 
          name: "Novo #{dish.name}",
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a dish with success' do
    dish = create_dish

    login_as dish.restaurant.user

    patch(
      restaurant_dish_path(dish.restaurant, dish), 
      params: { 
        dish: { 
          name: "Novo #{dish.name}",
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    expect(response).to redirect_to restaurant_dish_path(dish.restaurant, dish)
  end

  it 'fails to edit a dish with invalid data' do
    dish = create_dish

    login_as dish.restaurant.user

    patch(
      restaurant_dish_path(dish.restaurant, dish), 
      params: { 
        dish: { 
          name: '',
          description: dish.description,
          calories: dish.calories,
        }
      }
    )

    expect(response.status).to eq 422
  end
end