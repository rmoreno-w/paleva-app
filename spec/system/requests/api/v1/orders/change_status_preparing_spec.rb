require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/orders' do
    context 'fails when' do
      it 'informing the code of a restaurant that does not exist' do
        user = User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        Restaurant.create!(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '30.883.175/2481-06',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: user
        )


        post '/api/v1/order/prepare', params: { restaurant_code: 'XDB13200', order_code: 'AS8LOP42' }


        expect(response).to have_http_status :not_found
        expect(response.content_type).to include 'application/json'
      end

      it 'informing the code of an order that does not exist' do
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


        post '/api/v1/order/prepare', params: { restaurant_code: restaurant.code, order_code: 'AS8LOP42' }


        expect(response).to have_http_status :not_found
        expect(response.content_type).to include 'application/json'
      end

      it 'informing the code of an order that does not belong to the informed restaurant' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_user_order = Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: second_restaurant
        )


        post '/api/v1/order/prepare', params: { restaurant_code: restaurant.code, order_code: second_user_order.code }


        expect(response).to have_http_status :forbidden
        expect(response.content_type).to include 'application/json'
      end

      it 'the app goes through some unknown error' do
        user = User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        Restaurant.create!(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '30.883.175/2481-06',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: user
        )

        allow(Restaurant).to receive(:find_by).and_raise(StandardError)
        post '/api/v1/order/prepare', params: { restaurant_code: 'XDB13200', order_code: 'AS8LOP42'}


        expect(response).to have_http_status :internal_server_error
        expect(response.content_type).to include 'application/json'
      end
    end

    context 'succeeds' do
      it 'and changes the status of an order to "preparing"' do
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
        order = Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )


        post '/api/v1/order/prepare', params: { restaurant_code: restaurant.code, order_code: order.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
        json_data = JSON.parse(response.body)
        order = json_data['order']

        expect(order['status']).to eq 'preparing'
      end
    end
  end
end