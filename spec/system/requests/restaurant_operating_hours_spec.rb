require 'rails_helper'

describe 'User' do
  it 'creates a restaurant operating hour but is not authenticated' do
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

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_restaurant_operating_hour: { 
          start_time: '09:00',
          end_time: '10:00',
          status: 1,
          weekday: 1,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'creates a restaurant operating hour with success' do
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

    login_as restaurant.user

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_operating_hour: { 
          start_time: '09:00',
          end_time: '10:00',
          status: "1",
          weekday: "1",
        }
      }
    )

    expect(response).to redirect_to restaurant_restaurant_operating_hours_path(restaurant)
  end

  it 'fails to creates a restaurant operating hour with invalid data' do
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

    login_as restaurant.user

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_operating_hour: { 
          start_time: '',
          end_time: '10:00',
          status: "1",
          weekday: "1",
        }
      }
    )

    expect(response.status).to eq 422
  end
end