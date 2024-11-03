require 'rails_helper'

describe 'User' do
  context 'tries to access the tag creation page' do
    it 'but has to first be logged in' do
      dish = create_dish

      visit new_restaurant_tag_path(dish.restaurant)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
      expect(page).not_to have_content 'Cadastrar Tag'
    end

    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Cadastrar Tag'

      # Assert
      expect(current_path).to eq new_restaurant_tag_path(restaurant.id)
      expect(page).to have_content 'Cadastrar Tag'
    end
  end

  context 'creates a tag' do
    it 'and succeeds' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Cadastrar Tag'
      fill_in 'Nome', with: 'Vegano'
      click_on 'Criar Tag'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Cadastrar Tag'
      expect(page).to have_link 'Vegano'
    end

    it 'and fails when informing invalid data' do
      create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Cadastrar Tag'
      fill_in 'Nome', with: ''
      click_on 'Criar Tag'

      # Assert
      expect(page).to have_content 'Ops! :( Erro ao criar a Tag'
    end
  end

  context 'deletes a tag' do
    it 'and succeeds' do
      restaurant = create_restaurant_and_user
      Tag.create(name: 'Vegano', restaurant: restaurant)

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Remover Tag'
      select 'Vegano', from: 'Escolha uma Tag para excluir'
      click_on 'Excluir Tag'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).not_to have_link 'Vegano'
    end
  end
end
