require 'rails_helper'

describe 'User' do
  context 'tries to delete a dish' do
    it 'and should land in the correct page if it has a restaurant with a dish, seeing the button to delete' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_button 'Remover Prato'
      expect(page).to have_content dish.name
    end
  end

  context 'is logged in, has a restaurant, a dish, and deletes data of a dish' do
    it 'with succeess' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Remover Prato'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(dish.restaurant.id)
      expect(page).to have_content 'Prato deletado com sucesso'
    end
  end
end