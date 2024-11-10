require 'rails_helper'

describe 'User' do
  context 'navigate to the account creation page' do
    it 'and is on the correct page' do
      visit root_path
      click_on 'Criar Conta'

      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content 'Criar minha conta'
      expect(page).to have_button 'Cadastrar'
    end
  end

  context 'creates an account' do
    it 'and suceeds' do
      # Act
      visit root_path
      click_on 'Criar Conta'
      fill_in 'CPF', with: '08000661110'
      fill_in 'Nome', with: 'Aloisio'
      fill_in 'Sobrenome', with: 'Silveira'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      fill_in 'Confirme sua senha', with: 'fortissima12'
      click_on 'Cadastrar'

      # Assert
      # expect(current_path).to eq restaurants_path
      expect(page).to have_content 'Boas vindas! Sua conta foi criada com sucesso.'
      expect(page).to have_content 'Olá, Aloisio'
      expect(page).to have_content 'Sair'
      expect(page).not_to have_content 'Entrar'
    end

    it 'and suceeds. If there is a pre-registration with their email and registation number, they get already assigned to a restaurant' do
      restaurant_owner = User.create!(
        name: 'Adeilson',
        family_name: 'Souza',
        registration_number: CPF.generate,
        email: 'adeilson@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: restaurant_owner
      )
      restaurant.pre_registrations.create!(email: 'aloisio@email.com', registration_number: '08000661110')

      # Act
      visit root_path
      click_on 'Criar Conta'
      fill_in 'CPF', with: '08000661110'
      fill_in 'Nome', with: 'Aloisio'
      fill_in 'Sobrenome', with: 'Silveira'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      fill_in 'Confirme sua senha', with: 'fortissima12'
      click_on 'Cadastrar'

      # Assert
      staff_member = User.last
      pre_registration = PreRegistration.last
      expect(page).to have_content 'Boas vindas! Sua conta foi criada com sucesso.'
      expect(page).to have_content 'Olá, Aloisio'
      expect(staff_member.staff?).to eq true
      expect(staff_member.restaurant).to eq restaurant
      expect(pre_registration.registered?).to eq true

      expect(page).not_to have_content 'Criar meu restaurante'
      expect(page).to have_content 'Cardápios'
    end

    it 'and fails when informing invalid data' do
      visit root_path
      click_on 'Criar Conta'
      fill_in 'CPF', with: ''
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: 'Silveira'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      fill_in 'Confirme sua senha', with: 'fortissima12'
      click_on 'Cadastrar'

      # Assert
      # expect(current_path).to eq restaurants_path
      expect(page).to have_content 'CPF não pode ficar em branco'
      expect(page).to have_content 'CPF deve ser um número de CPF válido'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).not_to have_content 'Boas vindas! Sua conta foi criada com sucesso.'
      expect(page).not_to have_content 'Olá, Aloisio'
      expect(page).not_to have_content 'Sair'
    end
  end
end