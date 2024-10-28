require 'rails_helper'

describe 'User' do
  it 'creates a restaurant is not authenticated' do
    user = create_user

    post(
      restaurants_path(user), 
      params: { 
        restaurant: { 
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '30.883.175/2481-06',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
        }
      }
    )

    expect(response.status).to eq 401
    expect(response.body).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'creates a restaurant with success' do
    user = create_user
    login_as user

    post(
      restaurants_path(user), 
      params: { 
        restaurant: { 
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '30.883.175/2481-06',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          restaurant_operating_hours_attributes: { 
            "0": {
              start_time: '09:00',
              end_time: '10:00',
              status: "1",
              weekday: "1",
            }
          }
        }
      }
    )

    expect(response.status).to redirect_to root_path
  end

  it 'fails to creates a restaurant with invalid data' do
    user = create_user
    login_as user

    post(
      restaurants_path(user), 
      params: { 
        restaurant: { 
          brand_name: '',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '30.883.175/2481-06',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          restaurant_operating_hours_attributes: { 
            "0": {
              start_time: '09:00',
              end_time: '10:00',
              status: "1",
              weekday: "1",
            }
          }
        }
      }
    )

    expect(response.status).to eq 422
  end
end