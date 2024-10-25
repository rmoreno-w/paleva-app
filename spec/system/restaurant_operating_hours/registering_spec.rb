require 'rails_helper'

describe 'User' do
  context 'visits the page to manage the opening hours for a restaurant' do
    it 'but has to first be logged in' do
      create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Horários de Funcionamento'

      # Assert
      expect(page).to have_content 'Horários de Funcionamento'
    end
  end
end