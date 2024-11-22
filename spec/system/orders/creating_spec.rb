require 'rails_helper'

describe 'User' do
  context 'tries to access the page to register an order' do
    it 'but  has to be logged in' do
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
      dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create(itemable: dish)

      # Act
      visit restaurant_item_option_set_path(restaurant, item_set)
      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Almoço'
      expect(page).not_to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).not_to have_content '1 Bolinho e 1 Bola de Sorvete'
      expect(page).not_to have_content 'R$ 24,50'
    end

    it 'but first, adds an item from an item set with success' do
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
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create(itemable: dish)
      login_as user

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(dish.restaurant, item_set)
      expect(page).to have_content 'Item adicionado com sucesso ao Pedido!'
      # within('nav') do
      #   expect(page).to have_content '1 Item no Pedido'
      # end
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
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create(itemable: dish)
      login_as user

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click
      find("#serving_#{serving.id}").click
      click_on "Pedidos"
      find('#open-order-details').click

      fill_in 'Nome do Cliente', with: 'Aloisio Fonseca'
      fill_in 'E-mail do Cliente', with: 'aloisio_teste@email.com'
      fill_in 'Telefone do Cliente', with: '12999116633'
      fill_in 'CPF do Cliente (Opcional)', with: CPF.generate
      find("#serving_#{serving.id}").set 'Sem Glúten'
      click_on "Realizar Pedido"

      # Assert
      order = Order.last
      expect(current_path).to eq restaurant_orders_path(dish.restaurant)
      expect(page).to have_content 'Pedido realizado com Sucesso!'

      within('#order-history') do
        expect(page).to have_content "Pedido ##{order.code}"
        expect(page).to have_content "Status: #{I18n.t order.status}"
        expect(page).to have_content "Itens no Pedido: 1"
        expect(page).to have_content "Total do Pedido: R$ 49,00"
        expect(page).to have_content "Nome do Cliente: Aloisio Fonseca"
      end
    end

    it 'and succeeds, as a staff member' do
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
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create(itemable: dish)

      second_user = User.create!(
        name: 'Jacquin',
        family_name: 'DuFrance',
        registration_number: CPF.generate,
        email: 'ajc@cquin.com',
        password: 'fortissima12',
        role: :staff,
        restaurant: restaurant
      )
      login_as second_user

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click
      find("#serving_#{serving.id}").click
      click_on "Pedidos"

      fill_in 'Nome do Cliente', with: 'Aloisio Fonseca'
      fill_in 'E-mail do Cliente', with: 'aloisio_teste@email.com'
      fill_in 'Telefone do Cliente', with: '12999116633'
      fill_in 'CPF do Cliente (Opcional)', with: CPF.generate
      find("#serving_#{serving.id}").set 'Sem Glúten'
      click_on "Realizar Pedido"

      # Assert
      order = Order.last
      expect(current_path).to eq root_path
      expect(page).to have_content 'Pedido realizado com Sucesso!'
      expect(order.order_items.count).to eq 1
    end

    it 'and succeeds, applying discounts if they are active' do
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
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      item_set.item_option_entries.create(itemable: dish)
      login_as user

      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.day.ago.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      DiscountedServing.create!(discount: discount, serving: serving)

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click
      find("#serving_#{serving.id}").click
      click_on "Pedidos"
      find('#open-order-details').click

      fill_in 'Nome do Cliente', with: 'Aloisio Fonseca'
      fill_in 'E-mail do Cliente', with: 'aloisio_teste@email.com'
      fill_in 'Telefone do Cliente', with: '12999116633'
      fill_in 'CPF do Cliente (Opcional)', with: CPF.generate
      find("#serving_#{serving.id}").set 'Sem Glúten'
      click_on "Realizar Pedido"

      # Assert
      order = Order.last
      expect(current_path).to eq restaurant_orders_path(dish.restaurant)
      expect(page).to have_content 'Pedido realizado com Sucesso!'

      within('#order-history') do
        expect(page).to have_content "Pedido ##{order.code}"
        expect(page).to have_content "Status: #{I18n.t order.status}"
        expect(page).to have_content "Itens no Pedido: 1"
        expect(page).to have_content "Total do Pedido: R$ 41,65"
        expect(page).to have_content "Nome do Cliente: Aloisio Fonseca"
        discount.reload
        expect(discount.number_of_uses).to eq 1
      end
    end
  end
end