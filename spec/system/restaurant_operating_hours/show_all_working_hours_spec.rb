require 'rails_helper'

describe 'User' do
  context 'visits the page to register an operating hour for a restaurant' do
    it 'but first has to be logged in' do
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

      visit restaurant_restaurant_operating_hours_path(restaurant)

      # Assert
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Login'
    end

    it 'and should land in the correct page' do
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

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Horários'

      # Assert
      expect(current_path).to eq restaurant_restaurant_operating_hours_path(restaurant.id)
      expect(page).to have_link '+ Criar Horário'
    end

    it 'and succeeds' do
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
      restaurant.restaurant_operating_hours.create!(start_time: '09:00', end_time: '12:00', status: 1, weekday: 1)
      restaurant.restaurant_operating_hours.create!(start_time: '13:30', end_time: '17:30', status: 1, weekday: 1)
      restaurant.restaurant_operating_hours.create!(start_time: '19:00', end_time: '23:00', status: 1, weekday: 1)

      # Act
      visit root_path
      click_on 'Horários'

      # Assert
      expect(page).to have_content 'Horários de Funcionamento'
      expect(page).to have_content 'Segunda-feira - 09:00 às 12:00 - Aberto'
      expect(page).to have_content 'Segunda-feira - 13:30 às 17:30 - Aberto'
      expect(page).to have_content 'Segunda-feira - 19:00 às 23:00 - Aberto'
    end

    it 'and does not see operating hours from other restaurants' do
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
      restaurant.restaurant_operating_hours.create!(start_time: '09:00', end_time: '12:00', status: 1, weekday: 1)
      restaurant.restaurant_operating_hours.create!(start_time: '13:30', end_time: '17:30', status: 1, weekday: 1)
      restaurant.restaurant_operating_hours.create!(start_time: '19:00', end_time: '23:00', status: 1, weekday: 1)

      second_user = User.create!(
        name: 'Jacquin',
        family_name: 'DuFrance',
        registration_number: CPF.generate,
        email: 'ajc@cquin.com',
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
      second_restaurant.restaurant_operating_hours.create!(start_time: '17:00', end_time: '21:00', status: 1, weekday: 2)
      second_restaurant.restaurant_operating_hours.create!(start_time: '00:30', end_time: '04:30', status: 1, weekday: 2)


      # Act
      visit root_path
      click_on 'Horários'


      # Assert
      expect(page).to have_content 'Horários de Funcionamento'
      expect(page).to have_content 'Segunda-feira - 09:00 às 12:00 - Aberto'
      expect(page).to have_content 'Segunda-feira - 13:30 às 17:30 - Aberto'
      expect(page).to have_content 'Segunda-feira - 19:00 às 23:00 - Aberto'

      expect(page).not_to have_content 'Terça-feira - 17:00 às 21:00 - Aberto'
      expect(page).not_to have_content 'Quarta-feira - 00:30 às 04:30 - Aberto'
    end
  end
end