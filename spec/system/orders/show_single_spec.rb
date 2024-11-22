require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view one of their orders' do
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

    it 'and succeeds. If the order has discounts, show discounts for items and for grand total' do
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
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.00)
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      second_serving = beverage.servings.create!(description: 'Garrafa 750ml', current_price: 5.00)
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      item_set.item_option_entries.create!(itemable: beverage)
      first_discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 50,
        start_date: 1.day.ago.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      DiscountedServing.create!(discount: first_discount, serving: serving)
      second_discount = Discount.create!(
        name: 'Semana da Agua de Coco',
        percentage: 10,
        start_date: 1.day.ago.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      DiscountedServing.create!(discount: second_discount, serving: second_serving)
      login_as user

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click
      find("#serving_#{serving.id}").click
      find("#serving_#{second_serving.id}").click
      click_on "Pedidos"
      find('#open-order-details').click

      fill_in 'Nome do Cliente', with: 'Aloisio Fonseca'
      fill_in 'E-mail do Cliente', with: 'aloisio_teste@email.com'
      fill_in 'Telefone do Cliente', with: '12999116633'
      fill_in 'CPF do Cliente (Opcional)', with: CPF.generate
      find("#serving_#{serving.id}").set 'Sem Glúten'
      click_on "Realizar Pedido"
      order = Order.last
      visit restaurant_order_path(restaurant, order)


      # Assert
      expect(current_path).to eq restaurant_order_path(restaurant, order)

      expect(page).to have_content "Pedido ##{order.code}"
      expect(page).to have_content "Status: Aguardando confirmação da cozinha"
      expect(page).to have_content "2 Itens no Pedido"

      expect(page).to have_content "Sub-Total com Desconto"
      expect(page).to have_content "R$ 24,00"
      expect(page).to have_content "R$ 4,50"
      expect(page).to have_content "Total do Pedido"
      expect(page).to have_content "R$ 53,00"
      expect(page).to have_content "Total com Descontos"
      expect(page).to have_content "R$ 28,50"
      expect(page).to have_content "Dados do Cliente"
      expect(page).to have_content "Nome: Aloisio Fonseca"
      expect(page).to have_content "Telefone: 12999116633"
      expect(page).to have_content "E-mail: aloisio_teste@email.com"
      expect(page).to have_content "CPF: #{CPF.new(order.customer_registration_number).formatted}"
    end

    it 'and cannot access an order from other restaurants' do
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