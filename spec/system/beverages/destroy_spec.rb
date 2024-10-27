require 'rails_helper'

describe 'User' do
  context 'tries to delete a beverage' do
    it 'and should land in the correct page if it has a restaurant with a beverage, seeing the button to delete' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_button 'Remover Bebida'
      expect(page).to have_content beverage.name
    end
  end

  context 'is logged in, has a restaurant, a beverage, and deletes data of a beverage' do
    it 'with succeess' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Remover Bebida'

      # Assert
      expect(current_path).to eq restaurant_beverages_path(beverage.restaurant.id)
      expect(page).to have_content 'Bebida deletada com sucesso'
    end
  end
end