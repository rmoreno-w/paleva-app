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


        get '/api/v1/orders', params: { restaurant_code: 'XDB13200' }


        expect(response).to have_http_status :not_found
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
        get '/api/v1/orders', params: { restaurant_code: 'XDB13200' }


        expect(response).to have_http_status :internal_server_error
        expect(response.content_type).to include 'application/json'
      end
    end

    context 'succeeds' do
      it 'and returns an empty array when the restaurant does not have orders yet' do
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


        get '/api/v1/orders', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'
        expect(result_json.values[0].length).to eq 0
      end

      it 'when the code of a restaurant that exists and has orders is informed, without filters - separing orders by status' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )
        Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :delivered
        )
        Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :preparing
        )


        get '/api/v1/orders', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.keys).to include 'canceled'
        expect(orders.keys).to include 'delivered'
        expect(orders.keys).to include 'preparing'
        expect(orders['canceled'].length).to eq 1
        expect(orders['delivered'].length).to eq 1
        expect(orders['preparing'].length).to eq 1
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a "waiting_kitchen_approval" filter' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_order = Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )


        get '/api/v1/orders?status=waiting_kitchen_approval', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 2
        expect(orders[0].values).not_to include second_order.customer_name
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a "preparing" filter' do
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
        first_order = Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_order = Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        third_order = Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :preparing
        )


        get '/api/v1/orders?status=preparing', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 1
        expect(orders[0].values).not_to include first_order.customer_name
        expect(orders[0].values).not_to include second_order.customer_name
        expect(orders[0].values).to include third_order.customer_name
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a "canceled" filter' do
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
        first_order = Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_order = Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        third_order = Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )


        get '/api/v1/orders?status=canceled', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 1
        expect(orders[0].values).not_to include first_order.customer_name
        expect(orders[0].values).not_to include second_order.customer_name
        expect(orders[0].values).to include third_order.customer_name
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a "ready" filter' do
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
        first_order = Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_order = Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        third_order = Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :ready
        )


        get '/api/v1/orders?status=ready', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 1
        expect(orders[0].values).not_to include first_order.customer_name
        expect(orders[0].values).not_to include second_order.customer_name
        expect(orders[0].values).to include third_order.customer_name
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a "delivered" filter' do
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
        first_order = Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        second_order = Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        third_order = Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :delivered
        )


        get '/api/v1/orders?status=delivered', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 1
        expect(orders[0].values).not_to include first_order.customer_name
        expect(orders[0].values).not_to include second_order.customer_name
        expect(orders[0].values).to include third_order.customer_name
      end

      it 'when the code of a restaurant that exists and has orders is informed, returning an empty array when queried with a valid filter that has no orders' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )
        Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :ready
        )


        get '/api/v1/orders?status=delivered', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.length).to eq 0
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a status filter that is empty' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )


        get '/api/v1/orders?status=', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.keys).to include 'waiting_kitchen_approval'
        expect(orders['waiting_kitchen_approval'].length).to eq 2

        expect(orders.keys).to include 'canceled'
        expect(orders['canceled'].length).to eq 1
      end

      it 'when the code of a restaurant that exists and has orders is informed, with a status filter that is invalid' do
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
        Order.create!(
          customer_name: 'Adeilson Santos', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Abner Rodrigues', 
          customer_phone: '61999222299',
          customer_email: 'abner@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )
        Order.create!(
          customer_name: 'Adinomar Santos', 
          customer_phone: '35999224299',
          customer_email: 'adinomar@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant,
          status: :canceled
        )


        get '/api/v1/orders?status=abc123', params: { restaurant_code: restaurant.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'orders'

        orders = result_json['orders']
        expect(orders.keys).to include 'canceled'
        expect(orders.keys).to include 'waiting_kitchen_approval'
        expect(orders['canceled'].length).to eq 1
        expect(orders['waiting_kitchen_approval'].length).to eq 2
      end
    end
  end
end
