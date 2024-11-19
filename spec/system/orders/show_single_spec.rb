require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view all of their orders' do
    it 'but first has to be logged in' do
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

    it 'and should not see the orders history section if they are a staff member' do
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
      User.create!(
        name: 'Adeilson',
        family_name: 'Gomes',
        registration_number: CPF.generate(),
        email: 'adeilson@email.com',
        password: 'fortissima12',
        restaurant: restaurant,
        role: :staff
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'adeilson@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pedidos'

      # Assert
      expect(current_path).to eq restaurant_new_order_path(restaurant)
      expect(page).not_to have_selector 'section#order-history'
      expect(page).not_to have_selector 'h3', text: 'Últimos Pedidos'
    end

    it 'and succeeds' do
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
      login_as user

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