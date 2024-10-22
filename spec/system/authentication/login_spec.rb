require 'rails_helper'

describe 'User' do
  context 'navigate to the login page' do
    it 'and is on the correct page' do
      visit root_path
      click_on 'Entrar'

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Login'
      expect(page).to have_button 'Entrar'
    end
  end

  context 'logs in' do
    it 'and suceeds' do
      User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'

      # Assert
      expect(page).to have_content 'Login efetuado com sucesso.'
      expect(page).to have_content 'Olá, Aloisio'
      expect(page).to have_content 'Sair'
      expect(page).not_to have_content 'Entrar'
    end

    it 'and fails when informing invalid data' do
      User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'errada'
      click_on 'Entrar'

      # Assert
      expect(page).to have_content 'E-mail ou senha inválidos'
      expect(page).not_to have_content 'Olá, Aloisio'
      expect(page).not_to have_content 'Sair'
    end
  end
end