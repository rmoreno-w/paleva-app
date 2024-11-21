require 'rails_helper'

describe 'User' do
  context 'tries to access the page to view his item option sets' do
    it 'but first has to be logged in' do
      user = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      Restaurant.create!(
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

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_link 'Entrar'
      expect(page).to have_link 'Criar Conta'
    end

    it 'and should only see a link to item sets if a restaurant was previously created' do
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
      expect(page).not_to have_content 'Cardápios'
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
      Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
      ItemOptionSet.create!(name: 'Café da Manhã', restaurant: restaurant)
      ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      login_as user

      # Act
      visit root_path

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Café da Tarde'
      expect(page).to have_content 'Café da Manhã'
      expect(page).to have_content 'Almoço'
    end

    it 'and does not see item option sets from other restaurants' do
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
      Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
      ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      login_as user
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

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Cardápios'
      expect(page).to have_content 'Café da Tarde'
      expect(page).to have_content 'Almoço'
      expect(page).not_to have_content 'Pratos Franceses'
    end

    it 'and does not see an item option set that is not in season if they are a staff member' do
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
      Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
      ItemOptionSet.create!(
        name: 'Café da Tarde de Época',
        restaurant: restaurant,
        start_date: 1.month.from_now.to_fs(:db).split(' ').first,
        end_date: 2.months.from_now.to_fs(:db).split(' ').first
      )
      staff_member = User.create!(
        name: 'Jacquin',
        family_name: 'DuFrance',
        registration_number: CPF.generate,
        email: 'ajc@cquin.com',
        password: 'fortissima12',
        restaurant: restaurant,
        role: :staff
      )
      login_as staff_member

      # Act
      visit root_path

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Cardápios'
      expect(page).to have_content 'Almoço'
      expect(page).not_to have_content 'Café da Tarde de Época'
    end
  end
end