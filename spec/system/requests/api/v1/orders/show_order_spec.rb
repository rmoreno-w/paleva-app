require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/order' do
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


        get '/api/v1/order', params: { restaurant_code: 'XDB13200', order_code: 'AS8LOP42' }


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


        get '/api/v1/order', params: { restaurant_code: restaurant.code, order_code: 'AS8LOP42' }


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


        get '/api/v1/order', params: { restaurant_code: restaurant.code, order_code: second_user_order.code }


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
        get '/api/v1/order', params: { restaurant_code: 'XDB13200', order_code: 'AS8LOP42'}


        expect(response).to have_http_status :internal_server_error
        expect(response.content_type).to include 'application/json'
      end
    end

    context 'succeeds' do
      it 'and returns data about an order' do
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
        beverage = Beverage.create!(
          name: 'Agua de coco Sócoco',
          description: 'Já vem gelada, extraída do Coco in Natura, sem adicionais químicos',
          calories: 150,
          is_alcoholic: false,
          restaurant: restaurant
        )
        beverage_serving = Serving.create!(description: 'Garrafa 450ml', current_price: 8.70, servingable: beverage)
        dish = Dish.create!(
          name: 'Petit Gateau de Mousse Insuflado',
          description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
          calories: 580,
          restaurant: restaurant
        )
        dish_serving = Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 19.70, servingable: dish)
        OrderItem.create!(
          item_name: dish.name, 
          serving_description: dish_serving.description,
          serving_price: dish_serving.current_price,
          number_of_servings: 2,
          order: order
        )
        OrderItem.create!(
          item_name: beverage.name, 
          serving_description: beverage_serving.description,
          serving_price: beverage_serving.current_price,
          number_of_servings: 1,
          order: order
        )


        get '/api/v1/order', params: { restaurant_code: restaurant.code, order_code: order.code }


        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'

        result_json = JSON.parse(response.body)
        expect(result_json.keys).to include 'order'

        order = result_json['order']
        expect(order.keys).to include 'customer_name'
        expect(order.keys).to include 'status'
        expect(order.keys).to include 'code'
        expect(order.keys).to include 'date'
        expect(order.keys).to include 'items'
        expect(order.keys).to include 'total'

        items = order['items']
        expect(items.length).to eq 2
        expect(items[0].keys).to include 'item_name'
        expect(items[0].keys).to include 'serving_description'
        expect(items[0].keys).to include 'serving_price'
        expect(items[0].keys).to include 'number_of_servings'
        expect(items[0].keys).to include 'customer_notes'
        expect(items[0].keys).to include 'subtotal'
      end
    end
  end
end