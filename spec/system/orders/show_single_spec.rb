require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view all of their orders' do
    it 'but first has to be logged in' do
      dish = create_dish
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: dish.restaurant
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: serving.description,
        serving_price: serving.current_price,
        number_of_servings: 2,
        order: order
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: second_serving.description,
        serving_price: second_serving.current_price,
        number_of_servings: 1,
        order: order
      )

      # Act
      visit restaurant_order_path(dish.restaurant, order)

      # Assert
      expect(current_path).to eq new_user_session_path

      expect(page).not_to have_content "Pedido ##{order.code}"
      expect(page).not_to have_content "Status: Aguardando confirmação da cozinha"
      expect(page).not_to have_content "2 Itens no Pedido"
      
      expect(page).not_to have_content "Total do Pedido"
      expect(page).not_to have_content "R$ 85,75"
      expect(page).not_to have_content "Dados do Cliente"
      expect(page).not_to have_content "Nome: Adeilson Santos"
      expect(page).not_to have_content "Telefone: 35999222299"
      expect(page).not_to have_content "E-mail: adeilson@email.com"
      expect(page).not_to have_content "CPF: #{CPF.new(order.customer_registration_number).formatted}"
    end

    it 'and succeeds' do
      dish = create_dish
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: dish.restaurant
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: serving.description,
        serving_price: serving.current_price,
        number_of_servings: 2,
        order: order
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: second_serving.description,
        serving_price: second_serving.current_price,
        number_of_servings: 1,
        order: order
      )
      login_as dish.restaurant.user

      # Act
      visit restaurant_order_path(dish.restaurant, order)

      # Assert
      expect(current_path).to eq restaurant_order_path(dish.restaurant, order)

      expect(page).to have_content "Pedido ##{order.code}"
      expect(page).to have_content "Status: Aguardando confirmação da cozinha"
      expect(page).to have_content "2 Itens no Pedido"
      
      expect(page).to have_content "Total do Pedido"
      expect(page).to have_content "R$ 85,75"
      expect(page).to have_content "Dados do Cliente"
      expect(page).to have_content "Nome: Adeilson Santos"
      expect(page).to have_content "Telefone: 35999222299"
      expect(page).to have_content "E-mail: adeilson@email.com"
      expect(page).to have_content "CPF: #{CPF.new(order.customer_registration_number).formatted}"
    end

    it 'and cannot access orders from other restaurants' do
      dish = create_dish
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: dish.restaurant
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: serving.description,
        serving_price: serving.current_price,
        number_of_servings: 2,
        order: order
      )
      OrderItem.create!(
        item_name: dish.name, 
        serving_description: second_serving.description,
        serving_price: second_serving.current_price,
        number_of_servings: 1,
        order: order
      )
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
      second_order = Order.create!(
        customer_name: 'Adinomar Santos', 
        customer_phone: '35999222292',
        customer_email: 'adinomar@email.com',
        customer_registration_number: CPF.generate,
        restaurant: second_restaurant
      )
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: second_restaurant
      )
      second_serving = Serving.create!(description: 'Caixa de 1L', current_price: 12.5, servingable: beverage)
      OrderItem.create!(
        item_name: beverage.name, 
        serving_description: second_serving.description,
        serving_price: second_serving.current_price,
        number_of_servings: 1,
        order: second_order
      )

      # Act
      visit restaurant_order_path(dish.restaurant, second_order)

      # Assert
      expect(current_path).to eq root_path

      expect(page).to have_content "Voce não tem acesso a este Pedido"

      expect(page).not_to have_content "Pedido ##{second_order.code}"
      expect(page).not_to have_content "Status: Aguardando confirmação da cozinha"
      expect(page).not_to have_content "2 Itens no Pedido"
      
      expect(page).not_to have_content "Total do Pedido"
      expect(page).not_to have_content "R$ 12,50"
      expect(page).not_to have_content "Dados do Cliente"
      expect(page).not_to have_content "Nome: Adinomar Santos"
      expect(page).not_to have_content "Telefone: 35999222292"
      expect(page).not_to have_content "E-mail: adinomar@email.com"
      expect(page).not_to have_content "CPF: #{CPF.new(second_order.customer_registration_number).formatted}"
    end
  end
end