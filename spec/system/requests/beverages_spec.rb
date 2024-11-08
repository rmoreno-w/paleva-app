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

  it 'inactivates a beverage but is not authenticated' do
    beverage = create_beverage

    post(deactivate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'inactivates a beverage with success' do
    beverage = create_beverage
    login_as beverage.restaurant.user

    post(deactivate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response.status).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
  end

  it 'fails to inactivate a beverage with invalid data' do
    beverage = create_beverage
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
    beverage = create_beverage

    post(activate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response).to redirect_to new_user_session_path
  end

  it 'activates a beverage with success' do
    beverage = create_beverage
    beverage.inactive!
    login_as beverage.restaurant.user

    post(activate_restaurant_beverage_path(beverage.restaurant.id, beverage.id))

    expect(response.status).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
  end

  it 'fails to activate a beverage with invalid data' do
    beverage = create_beverage
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