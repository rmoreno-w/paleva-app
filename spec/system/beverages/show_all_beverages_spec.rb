require 'rails_helper'

describe 'User' do
  context 'tries to access the beverages listing page' do
    it 'but first, has to be logged in' do
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

      # Act
      visit restaurant_beverages_path(restaurant)

      # Assert
      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Bebidas do Meu Restaurante'
    end

    it 'and should only see a link to beverages if a restaurant was previously created' do
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
      expect(current_path).to eq new_restaurant_path
      expect(page).not_to have_content 'Bebidas'
    end

    it 'and should not see a link to beverages if they are a staff member' do
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
      expect(current_path).to eq root_path
      expect(page).not_to have_link 'Bebidas'
    end

    it 'and should land in the correct page if it has a restaurant' do
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

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'

      # Assert
      expect(current_path).to eq restaurant_beverages_path(restaurant.id)
      expect(page).to have_content 'Bebidas do Meu Restaurante'
    end

    it 'and should only see beverages from its own restaurant' do
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

      first_beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      second_beverage = Beverage.create!(
        name: 'Whisky Jack Daniels Honey',
        description: 'Garrafa de 750 ml',
        calories: 898,
        is_alcoholic: true,
        restaurant: restaurant
      )

      third_beverage = Beverage.create!(
        name: 'Coca Cola Zero Açucar 2L',
        description: 'Garrafa de Plástico Retornável. Converta em créditos caso não deseje mais usar a garrafa',
        calories: 97,
        is_alcoholic: false,
        restaurant: second_restaurant
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'

      # Assert
      expect(current_path).to eq restaurant_beverages_path(restaurant.id)
      expect(page).to have_content 'Bebidas do Meu Restaurante'
      expect(page).to have_content first_beverage.name
      expect(page).to have_content second_beverage.name
      expect(page).to have_content I18n.t(first_beverage.status)
      expect(page).to have_content I18n.t(second_beverage.status)
      expect(page).not_to have_content third_beverage.name
    end
  end
end
