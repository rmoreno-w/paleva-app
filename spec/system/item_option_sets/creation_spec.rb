require 'rails_helper'

describe 'User' do
  context 'tries to access the page to create a set of item options' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user

      # Act
      visit new_restaurant_item_option_set_path(restaurant)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
      create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_link 'Criar Cardápio'
    end
  end

  context 'creates a set of item options' do
    it 'with success' do
      dish = create_dish
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Criar Cardápio'
      fill_in 'Nome', with: 'Almoço'
      click_on 'Criar Cardápio'

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Cardápio criado com sucesso'
      expect(page).to have_content 'Almoço'
    end
  end
end