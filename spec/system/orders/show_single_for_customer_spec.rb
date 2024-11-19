require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view one of their orders' do
    it 'and gets to the correct page' do
      visit root_path
      click_on 'Acessar Pedido com Código'

      expect(current_path).to eq check_order_form_path

      expect(page).to have_content "Informe o Código do Pedido (8 dígitos) para obter mais informações"
      expect(page).to have_field "Código"
    end

    it 'and succeeds if the code of an existing order is informed' do
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
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
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
      visit check_order_form_path
      fill_in 'Código', with: order.code
      click_on 'Buscar Pedido'

      # Assert
      expect(current_path).to eq check_order_path
      
      expect(page).to have_content "Dados do Restaurante"
      expect(page).to have_content "Nome: #{order.restaurant.brand_name}"
      expect(page).to have_content "Endereço: #{order.restaurant.address}"
      expect(page).to have_content "E-mail: #{order.restaurant.email}"
      expect(page).to have_content "Telefone: #{order.restaurant.phone}"

      expect(page).to have_content "Dados do Pedido"
      expect(page).to have_content "Status: #{I18n.t(order.status)}"
      expect(page).to have_content "Criação"
    end

    it 'and fails if an invalid order code is informed' do
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
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
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
      visit check_order_form_path
      fill_in 'Código', with: order.code.chop
      click_on 'Buscar Pedido'

      # Assert
      expect(current_path).to eq check_order_path
      expect(page).to have_content "O código do Pedido deve ter 8 caracteres"
    end

    it 'and shows a message when a valid order code is informed, but the order doesnt exist' do
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
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      second_serving = dish.servings.create!(description: '2 Bolinhos e 2 Bolas de Sorvete, 50% de desconto no segundo', current_price: 36.75)
      order = Order.create!(
        customer_name: 'Adeilson Santos', 
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
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
      visit check_order_form_path
      fill_in 'Código', with: 'ABC12345'
      click_on 'Buscar Pedido'

      # Assert
      expect(current_path).to eq check_order_path
      expect(page).to have_content "Ops! :( Não foi possível achar um pedido com o Código informado"
    end
  end
end