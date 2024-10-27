require 'rails_helper'

describe 'User' do
  context 'tries to access the dish viewing page' do
    it 'and should get to the correct page, seeing the dish detail' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      expect(page).to have_content 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse'
      expect(page).to have_content '580'
    end

    it 'and should not be able to access a dish from another user' do
      restaurant = create_restaurant_and_user

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
      visit restaurant_dish_path(restaurant.id, first_dish.id)


      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Ops! Você não tem acesso a pratos que não são do seu restaurante'
      expect(page).not_to have_content first_dish.name
    end
  end
end
