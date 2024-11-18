require 'rails_helper'

describe 'User' do
  context 'tries to create a pre-registration of an users (employees) for their restaurant' do
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

      visit new_restaurant_staff_member_path(restaurant)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_selector 'h2', text: 'Pré-Cadastro'
    end

    it 'and gets to the correct page' do
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
      login_as restaurant.user

      visit root_path
      click_on 'Funcionários'
      click_on '+ Realizar Pré-Cadastro'

      expect(current_path).to eq new_restaurant_staff_member_path(restaurant)
      expect(page).to have_selector 'h2', text: 'Pré-Cadastro'
      expect(page).to have_field 'CPF'
      expect(page).to have_field 'E-mail'
    end

    it 'and succeed' do
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
      login_as restaurant.user

      visit root_path
      click_on 'Funcionários'
      click_on '+ Realizar Pré-Cadastro'
      fill_in 'E-mail', with: 'valente@email.com'
      fill_in 'CPF', with: CPF.generate
      click_on 'Cadastrar'

      pre_registration = PreRegistration.last
      expect(current_path).to eq restaurant_staff_members_path(restaurant)
      expect(page).to have_content 'Funcionários'
      # expect(page).to have_content 'Aqui você faz um pré-registro de seu funcionário, informando alguns dados. Assim que ele se cadastrar na plataforma, nosso sistema reconhece automaticamente e o associa a seu Restaurante! :)'
      expect(page).to have_content 'valente@email.com'
      expect(page).to have_content "#{CPF.new(pre_registration.registration_number).formatted}"
    end
  end
end
