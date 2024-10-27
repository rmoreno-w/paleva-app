require 'rails_helper'

describe 'User' do
  context 'tries to access the dish creation page' do
    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Criar Prato'

      # Assert
      expect(current_path).to eq new_restaurant_dish_path(restaurant.id)
      expect(page).to have_content 'Criar Prato'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Calorias'
      expect(page).to have_field 'Foto do Prato'
    end
  end

  context 'is logged in, has a restaurant, and tries to create a dish' do
    it 'and succeeds' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Criar Prato'
      
      fill_in 'Nome', with: 'Brownie de Chocolate Branco'
      fill_in 'Descrição', with: 'Deliciosa massa artesanal feita com chocolate sem açucar, nozes, macadâmia e farinha de aveia. Super fofinha, com casquinha e cobertura de ganache sem açúcar'
      fill_in 'Calorias', with: '378'
      attach_file 'Foto do Prato', Rails.root.join('spec', 'support', 'browniee.jpg')
      click_on 'Criar Prato'

      # Assert
      dish = Dish.last
      expect(current_path).to eq restaurant_dish_path(restaurant.id, dish.id)
      expect(page).to have_content 'Brownie de Chocolate Branco'
      expect(page).to have_content 'Deliciosa massa artesanal feita com chocolate sem açucar, nozes, macadâmia e farinha de aveia. Super fofinha, com casquinha e cobertura de ganache sem açúcar'
      expect(page).to have_content '378'
      expect(dish.picture.attached?).to eq true
      expect(page).to have_css('img[src*="browniee.jpg"]')
    end

    it 'and fails when informing invalid data' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Criar Prato'
      
      fill_in 'Nome', with: 'Brownie de Chocolate Branco'
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: '378'
      click_on 'Criar Prato'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Erro ao criar o prato'
      expect(page).not_to have_content 'Brownie de Chocolate Branco'
      expect(page).not_to have_content '378'
    end
  end
end