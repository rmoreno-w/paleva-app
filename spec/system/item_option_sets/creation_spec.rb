require 'rails_helper'

describe 'User' do
  context 'tries to access the item option set creation page' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user

      # Act
      visit new_restaurant_item_option_set_path(restaurant)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Cardápios'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(restaurant.id)
      expect(page).to have_link 'Criar Cardápio'
    end

    it 'and succeeds' do
      dish = create_dish
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Criar Cardápio'
      fill_in 'Nome', with: 'Almoço'
      click_on 'Criar Cardápio'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(dish.restaurant.id)
      expect(page).to have_content 'Cardápio criado com sucesso'
      expect(page).to have_content 'Almoço'
    end

    it 'and fails when informing invalid data' do
      dish = create_dish
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Cardápios'
      click_on 'Criar Cardápio'
      fill_in 'Nome', with: ''
      click_on 'Criar Cardápio'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(dish.restaurant.id)
      expect(page).not_to have_content 'Cardápio criado com sucesso'
      expect(page).to have_content 'Ops! :( Erro ao criar o Cardápio'
    end
  end
end