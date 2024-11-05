require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view his item option sets' do
    it 'but first has to be logged in' do
      restaurant = create_restaurant_and_user

      # Act
      visit restaurant_item_option_sets_path(restaurant)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant' do
      restaurant = create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Cardápios'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(restaurant.id)
      expect(page).to have_content 'Cardápios'
      expect(page).to have_link 'Criar Cardápio'
    end

    it 'and succeeds' do
      dish = create_dish
      ItemOptionSet.create!(name: 'Café da Tarde', restaurant: dish.restaurant)
      ItemOptionSet.create!(name: 'Café da Manhã', restaurant: dish.restaurant)
      ItemOptionSet.create!(name: 'Almoço', restaurant: dish.restaurant)
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Cardápios'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(dish.restaurant.id)
      expect(page).to have_content 'Cardápios'
      expect(page).to have_content 'Café da Tarde'
      expect(page).to have_content 'Café da Manhã'
      expect(page).to have_content 'Almoço'
    end

    it 'and does not see item option sets from other restaurants' do
      dish = create_dish
      ItemOptionSet.create!(name: 'Café da Tarde', restaurant: dish.restaurant)
      ItemOptionSet.create!(name: 'Almoço', restaurant: dish.restaurant)
      login_as dish.restaurant.user
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
      ItemOptionSet.create!(name: 'Pratos Franceses', restaurant: second_restaurant)

      # Act
      visit root_path
      click_on 'Cardápios'

      # Assert
      expect(current_path).to eq restaurant_item_option_sets_path(dish.restaurant.id)
      expect(page).to have_content 'Cardápios'
      expect(page).to have_content 'Café da Tarde'
      expect(page).to have_content 'Almoço'
      expect(page).not_to have_content 'Pratos Franceses'
    end
  end
end