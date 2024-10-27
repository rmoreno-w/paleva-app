require 'rails_helper'

describe 'User' do
  context 'tries to access the beverages listing page' do
    it 'and should only see a link to beverages if a restaurant was previously created' do
      create_user

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

    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

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
      restaurant = create_restaurant_and_user

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
      expect(page).not_to have_content third_beverage.name
    end
  end
end
