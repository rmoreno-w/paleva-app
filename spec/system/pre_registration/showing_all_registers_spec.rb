require 'rails_helper'

describe 'User' do
  context 'tries to access the listing of users (employees) they pre registered for their restaurant' do
    it 'but first needs to be authenticated' do
      user = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )

      visit restaurant_staff_members_path(restaurant)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Funcionários'
      expect(page).not_to have_link '+ Realizar Pré-Cadastro'
    end

    it 'and gets to the correct page, seeing staff members for their restaurant' do
      user = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )
      login_as user
      PreRegistration.create!(email: 'ken@errero.com', registration_number: CPF.generate, restaurant: restaurant)
      pre_registration_to_confirm = PreRegistration.create!(email: 'valente@email.com', registration_number: CPF.generate, restaurant: restaurant)
      User.create!(
        name: 'Valente',
        family_name: 'Santos',
        registration_number: pre_registration_to_confirm.registration_number,
        email: pre_registration_to_confirm.email,
        password: 'fortissima12'
      )

      visit restaurant_staff_members_path(restaurant)

      expect(current_path).to eq restaurant_staff_members_path(restaurant)
      expect(page).to have_content 'valente@email.com'
      expect(page).to have_content "Registrado ✅"
      expect(page).to have_content 'ken@errero.com'
      expect(page).to have_content "Pendente 🟠"
    end

    it 'and should not see a link to the staffing page if they are a staff member' do
      user = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )
      User.create!(
        name: 'Adeilson',
        family_name: 'Gomes',
        registration_number: CPF.generate(),
        email: 'adeilson@email.com',
        password: 'fortissima12',
        restaurant: restaurant,
        role: :staff
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'adeilson@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'

      # Assert
      expect(page).not_to have_link 'Funcionários'
    end

    it 'and doesnt see pre registrations from other restaurants' do
      user = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )
      login_as user

      PreRegistration.create!(email: 'ken@errero.com', registration_number: CPF.generate, restaurant: restaurant)
      pre_registration_to_confirm = PreRegistration.create!(email: 'valente@email.com', registration_number: CPF.generate, restaurant: restaurant)

      User.create!(
        name: 'Valente',
        family_name: 'Santos',
        registration_number: pre_registration_to_confirm.registration_number,
        email: pre_registration_to_confirm.email,
        password: 'fortissima12'
      )
      second_user = User.create!(
        name: 'Jacquin',
        family_name: 'Boulevard',
        registration_number: CPF.generate,
        email: 'jacquin@email.com',
        password: 'fortissima12'
      )
      second_restaurant = Restaurant.create!(
          brand_name: 'Boulangerie JQ',
          corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
          registration_number: CNPJ.generate,
          address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
          phone: '12988774532',
          email: 'atendimento@bjq.com.br',
          user: second_user
        )
      PreRegistration.create!(email: 'sobrinho_do_jacquin@email.com', registration_number: CPF.generate, restaurant: second_restaurant)

      visit restaurant_staff_members_path(restaurant)

      expect(current_path).to eq restaurant_staff_members_path(restaurant)
      expect(page).to have_content 'valente@email.com'
      expect(page).to have_content "Registrado ✅"
      expect(page).to have_content 'ken@errero.com'
      expect(page).to have_content "Pendente 🟠"

      expect(page).not_to have_content 'sobrinho_do_jacquin@email.com'
    end
  end
end
