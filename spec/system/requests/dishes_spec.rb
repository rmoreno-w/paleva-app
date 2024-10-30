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

  it 'inactivates a dish but is not authenticated' do
    dish = create_dish

    post(deactivate_restaurant_dish_path(dish.restaurant.id, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'inactivates a dish with success' do
    dish = create_dish
    login_as dish.restaurant.user

    post(deactivate_restaurant_dish_path(dish.restaurant.id, dish.id))

    expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
  end

  it 'fails to inactivate a dish with invalid data' do
    dish = create_dish
    login_as dish.restaurant.user
    second_user = User.create!(
      name: 'Jacquin',
      family_name: 'DuFrance',
      registration_number: CPF.generate,
      email: 'ajc@cquin.com',
      password: 'fortissima12'
    )

    second_restaurant = Restaurant.create!(
      brand_name: 'Boulangerie JQ',
      corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
      registration_number: CNPJ.generate,
      address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
      phone: '12988774532',
      email: 'atendimento@bjq.com.br',
      user: second_user
    )

    second_dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: second_restaurant
    )

    post(deactivate_restaurant_dish_path(dish.restaurant.id, second_dish.id))

    expect(response).to redirect_to root_path
  end

  it 'activates a dish but is not authenticated' do
    dish = create_dish

    post(activate_restaurant_dish_path(dish.restaurant.id, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'activates a dish with success' do
    dish = create_dish
    dish.inactive!
    login_as dish.restaurant.user

    post(activate_restaurant_dish_path(dish.restaurant.id, dish.id))

    expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
  end

  it 'fails to activate a dish with invalid data' do
    dish = create_dish
    dish.inactive!
    login_as dish.restaurant.user
    second_user = User.create!(
      name: 'Jacquin',
      family_name: 'DuFrance',
      registration_number: CPF.generate,
      email: 'ajc@cquin.com',
      password: 'fortissima12'
    )

    second_restaurant = Restaurant.create!(
      brand_name: 'Boulangerie JQ',
      corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
      registration_number: CNPJ.generate,
      address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
      phone: '12988774532',
      email: 'atendimento@bjq.com.br',
      user: second_user
    )

    second_dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: second_restaurant
    )

    post(activate_restaurant_dish_path(dish.restaurant.id, second_dish.id))

    expect(response).to redirect_to root_path
  end
end