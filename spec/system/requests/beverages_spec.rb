require 'rails_helper'

describe 'User' do
  it 'creates a beverage but is not authenticated' do
    beverage = create_beverage

    post(
      restaurant_beverages_path(beverage.restaurant), 
      params: { 
        beverage: { 
          name: beverage.name,
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'creates a beverage with success' do
    restaurant = create_restaurant_and_user
    beverage = new_beverage

    login_as restaurant.user

    post(
      restaurant_beverages_path(restaurant), 
      params: { 
        beverage: { 
          name: beverage.name,
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    beverage = Beverage.last
    expect(response.status).to redirect_to restaurant_beverage_path(restaurant, beverage)
  end

  it 'fails to creates a beverage with invalid data' do
    restaurant = create_restaurant_and_user
    beverage = new_beverage

    login_as restaurant.user

    post(
      restaurant_beverages_path(restaurant), 
      params: { 
        beverage: { 
          name: '',
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    expect(response.status).to eq 422
  end

  it 'deletes a beverage but is not authenticated' do
    beverage = create_beverage

    delete(restaurant_beverage_path(beverage.restaurant, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a beverage but is not authenticated' do
    beverage = create_beverage

    patch(
      restaurant_beverage_path(beverage.restaurant.id, beverage.id), 
      params: { 
        beverage: { 
          name: "Novo #{beverage.name}",
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a beverage with success' do
    beverage = create_beverage

    login_as beverage.restaurant.user

    patch(
      restaurant_beverage_path(beverage.restaurant, beverage), 
      params: { 
        beverage: { 
          name: "Novo #{beverage.name}",
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    expect(response).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
  end

  it 'fails to edit a beverage with invalid data' do
    beverage = create_beverage

    login_as beverage.restaurant.user

    patch(
      restaurant_beverage_path(beverage.restaurant, beverage), 
      params: { 
        beverage: { 
          name: '',
          description: beverage.description,
          calories: beverage.calories,
          is_alcoholic: beverage.is_alcoholic,
        }
      }
    )

    expect(response.status).to eq 422
  end
end