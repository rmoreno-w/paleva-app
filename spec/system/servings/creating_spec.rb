require 'rails_helper'

describe 'User' do
  context 'tries to create a serving for a dish' do
    it 'and gets the correct page' do
      dish = create_dish
      login_as dish.restaurant.user

      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Cadastrar Porção'

      expect(current_path).to eq new_restaurant_dish_serving_path(dish.restaurant, dish)
      expect(page).to have_content 'Nova Porção'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço Atual'
      expect(page).to have_button 'Criar Porção'
    end
  end
  context 'tries to create a serving for a beverage' do
    it 'and gets the correct page' do
      beverage = create_beverage
      login_as beverage.restaurant.user

      visit root_path
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Cadastrar Porção'

      expect(current_path).to eq new_restaurant_beverage_serving_path(beverage.restaurant, beverage)
      expect(page).to have_content 'Nova Porção'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço Atual'
      expect(page).to have_button 'Criar Porção'
    end
  end
end