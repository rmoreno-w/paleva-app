require 'rails_helper'

describe 'User' do
  context 'tries to access the page to remove an item from a set of item options' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

      # Act
      visit restaurant_item_option_set_remove_item_path(restaurant, option_set)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      option_set.item_option_entries.create(itemable: beverage)
      login_as restaurant.user

      # Act
      visit root_path
      click_on 'Almoço'
      click_on 'Remover Prato/Bebida'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_remove_item_path(restaurant, option_set)
      expect(page).to have_selector 'h2', text: "Remover Item de #{option_set.name}"
    end

    it 'and should only see the button to remove items if there is already an item in the item set' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user
      item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

      # Act
      visit root_path
      click_on 'Café da Tarde'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).not_to have_link 'Remover Prato/Bebida'
    end

    it 'and removes a dish with success' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      dish = Dish.new(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

      second_dish = Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: restaurant
      )
      second_dish.servings.create(description: 'Pequena - 20x20cm', current_price: 8.9)

      item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

      item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: second_dish)


      # Act
      visit root_path
      click_on 'Café da Tarde'
      click_on 'Remover Prato/Bebida do Cardápio'
      select 'Tortinha de Maçã', from: 'Itens Disponíveis'
      click_on 'Remover'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).to have_content "Item #{second_dish.name} removido do Cardápio com sucesso!"
      within 'ul' do
        expect(page).to have_content 'Agua de coco Sócoco'
        expect(page).to have_content 'R$ 12,50'
        expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
        expect(page).to have_content 'R$ 18,90'
        expect(page).not_to have_content 'Tortinha de Maçã'
        expect(page).not_to have_content 'R$ 8,90'
      end
    end

    it 'and removes a beverage from a set of item options with success' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user
      item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      dish = Dish.new(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

      second_beverage = Beverage.create!(
        name: 'Coca Cola',
        description: 'Zero Açúcar',
        calories: 7,
        is_alcoholic: false,
        restaurant: restaurant
      )
      second_beverage.servings.create(description: 'Garrafa 600ml', current_price: 4.9)

      item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: second_beverage)


      # Act
      visit root_path
      click_on 'Café da Tarde'
      click_on 'Remover Prato/Bebida do Cardápio'
      select 'Coca Cola', from: 'Itens Disponíveis'
      click_on 'Remover'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).to have_content "Item #{second_beverage.name} removido do Cardápio com sucesso!"
      within 'ul' do
        expect(page).to have_content 'Agua de coco Sócoco'
        expect(page).to have_content 'R$ 12,50'
        expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
        expect(page).to have_content 'R$ 18,90'

        expect(page).not_to have_content 'Coca Cola'
        expect(page).not_to have_content 'R$ 4,90'
      end
    end

    it 'and only sees items that are already in the set in the select options' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      dish = Dish.new(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

      item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

      item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)

      Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: restaurant
      )

      # Act
      visit root_path
      click_on 'Café da Tarde'
      click_on 'Remover Prato/Bebida do Cardápio'


      # Assert
      expect(current_path).to eq restaurant_item_option_set_remove_item_path(restaurant.id, item_set.id)
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'

      expect(page).not_to have_content 'Tortinha de Maçã'
    end
  end
end