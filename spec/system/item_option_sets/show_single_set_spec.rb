require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view an item option set' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)

      # Act
      visit restaurant_item_option_set_path(restaurant, item_set)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and an item set' do
      restaurant = create_restaurant_and_user
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      login_as restaurant.user

      # Act
      visit restaurant_item_option_set_path(restaurant, item_set)

      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant, item_set)
      expect(page).to have_selector 'h2', text: 'Cardápio - Almoço'
      # expect(page).to have_link 'Adicionar Prato'
      # expect(page).to have_link 'Adicionar Bebida'
    end

    it 'and should show the dishes, beverages, and servings linked to that Option Set' do
      restaurant = create_restaurant_and_user
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
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

      item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
      item_set.item_option_entries.create(itemable: beverage)
      login_as restaurant.user


      # Act
      visit restaurant_item_option_set_path(restaurant, item_set)


      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant, item_set)
      expect(page).to have_selector 'h2', text: 'Cardápio - Almoço'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Garrafa 750ml'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).to have_content '1 Bolinho + 1 Bola de Sorvete'
    end

    it 'and should show the dishes, beverages, and servings linked to that Option Set' do
      restaurant = create_restaurant_and_user
      item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      item_set.item_option_entries.create(itemable: beverage)
      
      dish = Dish.new(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)
      item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)

      dish_that_is_not_in_the_set = Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: restaurant
      )
      dish_that_is_not_in_the_set.servings.create(description: 'Pequena - 20x20cm', current_price: 8.9)

      login_as restaurant.user


      # Act
      visit restaurant_item_option_set_path(restaurant, item_set)


      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant, item_set)
      expect(page).to have_selector 'h2', text: 'Cardápio - Almoço'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Garrafa 750ml'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).to have_content '1 Bolinho + 1 Bola de Sorvete'

      expect(page).not_to have_content 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela'
      expect(page).not_to have_content 'Pequena - 20x20cm'
    end

    it 'and does not see item option sets from other restaurants' do
      restaurant = create_restaurant_and_user
      item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      item_set.item_option_entries.create!(itemable: beverage)
      login_as restaurant.user
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
      second_item_set = ItemOptionSet.create!(name: 'Pratos Alemães', restaurant: second_restaurant)
      dish_that_is_not_in_the_set = Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: second_restaurant
      )
      dish_that_is_not_in_the_set.servings.create(description: 'Pequena - 20x20cm', current_price: 8.9)
      second_item_set.item_option_entries.create!(itemable: dish_that_is_not_in_the_set)

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Café da Tarde'


      # Assert
      expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
      expect(page).to have_content 'Cardápio'
      expect(page).to have_content 'Café da Tarde'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Garrafa 750ml'
      expect(page).not_to have_content 'Pratos Alemães'
      expect(page).not_to have_content 'Tortinha de Maçã'
      expect(page).not_to have_content 'Pequena - 20x20cm'
    end
  end
end