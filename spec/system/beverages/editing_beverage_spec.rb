require 'rails_helper'

describe 'User' do
  context 'tries to access the beverage edition page' do
    it 'and should not be able to edit a beverage from another user' do
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

      Beverage.create!(
        name: 'Whisky Jack Daniels Honey',
        description: 'Garrafa de 750 ml',
        calories: 898,
        is_alcoholic: true,
        restaurant: second_restaurant
      )

      # Act
      login_as second_user
      visit edit_restaurant_beverage_path(restaurant.id, first_beverage.id)


      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Ops! Você não tem acesso a bebidas que não são do seu restaurante'
      expect(page).not_to have_content first_beverage.name
    end

    it 'and should land in the correct page if it has a restaurant with a beverage' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Alterar Bebida'

      # Assert
      expect(current_path).to eq edit_restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Alterar Bebida'
      expect(page).to have_field 'Nome', with: beverage.name
    end
  end

  context 'is logged in, has a restaurant, and edits data of a beverage' do
    it 'and succeeds' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Alterar Bebida'
      fill_in 'Nome', with: 'Água de coco KeroCoco'
      click_on 'Atualizar Bebida'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Bebida alterada com sucesso'
      expect(page).to have_content 'Água de coco KeroCoco'
    end

    it 'and fails when informing invalid data' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Alterar Bebida'
      fill_in 'Nome', with: ''
      click_on 'Atualizar Bebida'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Erro ao alterar a bebida'
      expect(page).to have_field 'Nome', with: ''
    end
  end
end