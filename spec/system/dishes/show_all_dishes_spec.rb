require 'rails_helper'

describe 'User' do
  context 'tries to access the dish listing page' do
    it 'and should only see a link to dishes if a restaurant was previously created' do
      create_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'

      # Assert
      expect(current_path).to eq new_restaurant_path
      expect(page).not_to have_content 'Pratos'
    end

    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Pratos do Meu Restaurante'
    end

    it 'and should only see dishes from its own restaurant' do
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

      first_dish = Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestle 150g',
        calories: 258,
        restaurant: restaurant
      )

      second_dish = Dish.create!(
        name: 'Pacote de Bala 7 Belo',
        description: 'Pacote de 150 unidades. Peso 700g',
        calories: 3650,
        restaurant: restaurant
      )

      third_dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: second_restaurant
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Pratos do Meu Restaurante'
      expect(page).to have_content first_dish.name
      expect(page).to have_content second_dish.name
      expect(page).not_to have_content third_dish.name
    end
  end
end
