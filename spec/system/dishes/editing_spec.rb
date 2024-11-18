require 'rails_helper'

describe 'User' do
  context 'tries to access the dish edition page' do
    it 'and should not be able to edit a dish from another user' do
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

      first_dish = Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestle 150g',
        calories: 258,
        restaurant: restaurant
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

      Dish.create!(
        name: 'Pacote de Bala 7 Belo',
        description: 'Pacote de 150 unidades. Peso 700g',
        calories: 3650,
        restaurant: second_restaurant
      )

      # Act
      login_as second_user
      visit edit_restaurant_dish_path(restaurant.id, first_dish.id)


      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem acesso a este restaurante'
      expect(page).not_to have_content first_dish.name
    end

    it 'and should land in the correct page if it has a restaurant with a dish' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Alterar Prato'

      # Assert
      expect(current_path).to eq edit_restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Alterar Prato'
      expect(page).to have_field 'Nome', with: dish.name
    end
  end

  context 'is logged in, has a restaurant, and edits data of a dish' do
    it 'and succeeds' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Alterar Prato'
      fill_in 'Nome', with: 'Grand Gateau'
      click_on 'Atualizar Prato'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Prato alterado com sucesso'
      expect(page).to have_content 'Grand Gateau'
    end

    it 'and fails when informing invalid data' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Alterar Prato'
      fill_in 'Nome', with: ''
      click_on 'Atualizar Prato'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Erro ao alterar o prato'
      expect(page).to have_field 'Nome', with: ''
    end
  end
end