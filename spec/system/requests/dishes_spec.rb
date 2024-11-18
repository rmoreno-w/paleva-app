require 'rails_helper'

describe 'User' do
  it 'creates a dish but is not authenticated' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )

    dish = Dish.new(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
    )

    login_as user

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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.new(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
    )

    login_as user

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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    delete(restaurant_dish_path(dish.restaurant, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a dish but is not authenticated' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    patch(
      restaurant_dish_path(restaurant.id, dish.id), 
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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    login_as user

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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    login_as user

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
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    post(deactivate_restaurant_dish_path(restaurant.id, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'inactivates a dish with success' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )
    login_as user

    post(deactivate_restaurant_dish_path(restaurant.id, dish.id))

    expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
  end

  it 'fails to inactivate a dish with invalid data' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )
    login_as user
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


    post(deactivate_restaurant_dish_path(restaurant.id, second_dish.id))


    expect(response).to redirect_to root_path
  end

  it 'activates a dish but is not authenticated' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )

    post(activate_restaurant_dish_path(restaurant.id, dish.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'activates a dish with success' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )
    dish.inactive!
    login_as user

    post(activate_restaurant_dish_path(restaurant.id, dish.id))

    expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
  end

  it 'fails to activate a dish with invalid data' do
    user = User.create!(
      name: 'Aloisio',
      family_name: 'Silveira',
      registration_number: '08000661110',
      email: 'aloisio@email.com',
      password: 'fortissima12'
    )
    restaurant = Restaurant.create!(
      brand_name: 'Pizzaria Campus du Codi',
      corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
      registration_number: '30.883.175/2481-06',
      address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
      phone: '12987654321',
      email: 'campus@ducodi.com.br',
      user: user
    )
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )
    dish.inactive!
    login_as user
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


    post(activate_restaurant_dish_path(restaurant.id, second_dish.id))


    expect(response).to redirect_to root_path
  end
end