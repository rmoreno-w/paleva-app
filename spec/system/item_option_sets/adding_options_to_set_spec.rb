require 'rails_helper'

describe 'User' do
  context 'tries to access the page to add a dish to a set of item options' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

      # Act
      visit restaurant_item_option_set_new_dish_path(restaurant, option_set)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)
      login_as restaurant.user

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Almoço'
      click_on 'Adicionar Prato'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_new_dish_path(restaurant, option_set)
      expect(page).to have_selector 'h2', text: "Adicionar Prato a #{option_set.name}"
    end

    it 'and adds a dish with success' do
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

      dish_to_be_added_to_the_set = Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: restaurant
      )
      dish_to_be_added_to_the_set.servings.create(description: 'Pequena - 20x20cm', current_price: 8.9)


      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Café da Tarde'
      click_on 'Adicionar Prato ao Cardápio'
      select 'Tortinha de Maçã', from: 'Pratos Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).to have_content "Prato #{dish_to_be_added_to_the_set.name} adicionado ao Cardápio com sucesso!"
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'R$ 12,50'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).to have_content 'R$ 18,90'
      expect(page).to have_content 'Tortinha de Maçã'
      expect(page).to have_content 'R$ 8,90'
    end

    it 'and does not see a dish that is already on the set in the select options' do
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
      click_on 'Cardápios'
      click_on 'Café da Tarde'
      click_on 'Adicionar Prato ao Cardápio'


      # Assert
      expect(current_path).to eq restaurant_item_option_set_new_dish_path(restaurant.id, item_set.id)
      expect(page).to have_content 'Tortinha de Maçã'

      expect(page).not_to have_content 'Petit Gateau de Mousse Insuflado'
    end
  end

  context 'tries to access the page to add a beverage to a set of item options' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

      # Act
      visit restaurant_item_option_set_new_beverage_path(restaurant, option_set)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
      restaurant = create_restaurant_and_user
      option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)
      login_as restaurant.user

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Almoço'
      click_on 'Adicionar Bebida'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_new_beverage_path(restaurant, option_set)
      expect(page).to have_selector 'h2', text: "Adicionar Bebida a #{option_set.name}"
    end

    it 'and adds a beverage to a set of item options with success' do
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

      beverage_to_be_added_to_the_set = Beverage.create!(
        name: 'Coca Cola',
        description: 'Zero Açúcar',
        calories: 7,
        is_alcoholic: false,
        restaurant: restaurant
      )
      beverage_to_be_added_to_the_set.servings.create(description: 'Garrafa 600ml', current_price: 4.9)


      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Café da Tarde'
      click_on 'Adicionar Bebida ao Cardápio'
      select 'Coca Cola', from: 'Bebidas Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).to have_content "Bebida #{beverage_to_be_added_to_the_set.name} adicionada ao Cardápio com sucesso!"
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'R$ 12,50'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).to have_content 'R$ 18,90'
      expect(page).to have_content 'Coca Cola'
      expect(page).to have_content 'R$ 4,90'
    end

    it 'and does not see a beverage that is already on the set in the select options' do
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

      Beverage.create!(
        name: 'Coca Cola',
        description: 'Zero Açucar',
        calories: 7,
        restaurant: restaurant
      )

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Café da Tarde'
      click_on 'Adicionar Bebida ao Cardápio'


      # Assert
      expect(current_path).to eq restaurant_item_option_set_new_beverage_path(restaurant.id, item_set.id)
      expect(page).to have_content 'Coca Cola'

      expect(page).not_to have_content 'Agua de coco Sócoco'
    end
  end
end