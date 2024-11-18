require 'rails_helper'

describe 'User' do
  it 'creates a beverage but is not authenticated' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

    delete(restaurant_beverage_path(beverage.restaurant, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'edits a beverage but is not authenticated' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

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

  it 'inactivates a beverage but is not authenticated' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

    post(deactivate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'inactivates a beverage with success' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )
    login_as beverage.restaurant.user

    post(deactivate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response.status).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
  end

  it 'fails to inactivate a beverage with invalid data' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )
    login_as beverage.restaurant.user
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

    second_beverage = Beverage.create!(
      name: 'Coca Cola Zero Açucar 2L',
      description: 'Garrafa de Plástico Retornável. Converta em créditos caso não deseje mais usar a garrafa',
      calories: 97,
      is_alcoholic: false,
      restaurant: second_restaurant
    )

    post(deactivate_restaurant_beverage_path(beverage.restaurant.id, second_beverage.id))

    expect(response).to redirect_to root_path
  end

  it 'activates a beverage but is not authenticated' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

    post(activate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'activates a beverage with success' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )
    beverage.inactive!
    login_as beverage.restaurant.user

    post(activate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response.status).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
  end

  it 'fails to activate a beverage with invalid data' do
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
    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )
    beverage.inactive!
    login_as beverage.restaurant.user
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

    second_beverage = Beverage.create!(
      name: 'Coca Cola Zero Açucar 2L',
      description: 'Garrafa de Plástico Retornável. Converta em créditos caso não deseje mais usar a garrafa',
      calories: 97,
      is_alcoholic: false,
      restaurant: second_restaurant
    )

    post(activate_restaurant_beverage_path(beverage.restaurant.id, second_beverage.id))

    expect(response).to redirect_to root_path
  end
end