require 'rails_helper'

describe 'User' do
  context 'tries to access the page to register an order' do
    it 'but first, adds an item from an item set with success' do
      dish = create_dish
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: dish.restaurant)
      item_set.item_option_entries.create(itemable: dish)
      login_as dish.restaurant.user

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
      dish = create_dish
      serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.50)
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: dish.restaurant)
      item_set.item_option_entries.create(itemable: dish)
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Almoço'
      find("#serving_#{serving.id}").click
      find("#serving_#{serving.id}").click
      click_on "Pedidos"
      #click_on "Detalhes"
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
  end
end