require 'rails_helper'

describe 'User' do
  context 'tries to access the beverage viewing page' do
    it 'and should get to the correct page, seeing the beverage detail' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Caixa de 1L. Já vem gelada'
      expect(page).to have_content '150'
      expect(page).to have_content '❌'
      expect(page).to have_content 'Ativo 🟢'
    end

    it 'and should not be able to access a beverage from another user' do
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
      visit restaurant_beverage_path(restaurant.id, first_beverage.id)


      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Ops! Você não tem acesso a bebidas que não são do seu restaurante'
      expect(page).not_to have_content first_beverage.name
    end

    it 'and should see the button to inactivate a beverage, if it is active (default)' do
      beverage = create_beverage

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_button 'Desativar Bebida'
    end

    it 'and should see the button to activate a beverage, if it is inactive' do
      beverage = create_beverage
      beverage.inactive!

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_button 'Ativar Bebida'
    end

    it 'and should see the serving options of a beverage' do
      beverage = create_beverage

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'

      # Assert
      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Porções:'
      expect(page).to have_content "Nenhuma porção cadastrada para #{beverage.name}"
      # expect(page).to have_link 'Cadastrar Porção'
      expect(page).to have_content 'Cadastrar Porção'
    end
  end
end
