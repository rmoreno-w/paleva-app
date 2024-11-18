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
      click_on 'Pratos'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Pratos do Meu Restaurante'
    end

    it 'and should only see dishes from its own restaurant' do
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
      expect(page).to have_content I18n.t(first_dish.status)
      expect(page).to have_content I18n.t(second_dish.status)
      expect(page).not_to have_content third_dish.name
      expect(page).to have_content 'Filtrar:'
      within '#filters' do
        expect(page).to have_selector 'button', count: restaurant.tags.count
      end
    end

    it 'and should see all the tags for dishes from its own restaurant' do
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

      Tag.create!(name: 'Vegano', restaurant: restaurant)
      Tag.create!(name: 'Alto em Açúcar', restaurant: restaurant)

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'

      # Assert
      expect(current_path).to eq restaurant_dishes_path(restaurant.id)
      expect(page).to have_content 'Filtrar:'
      within '#filters-container' do
        expect(page).to have_selector 'a', count: restaurant.tags.count + 1
      end
    end

    it 'and should see only the dishes marked with a tag when clicking on a tag button' do
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

      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)
      Tag.create!(name: 'Alto em Açúcar', restaurant: restaurant)

      dish = Dish.create!(
        name: 'Tapioca de Coco',
        description: 'Massa de tapioca e recheio de creme de coco',
        calories: 258,
        restaurant: restaurant
      )
      dish.tags << tag

      Dish.create!(
        name: 'Bolo Floresta Negra',
        description: 'Massa de chocolate, cobertura de Chantilly e ganache, e recheio de mousse de chocolate. Cerejas picadas adornando e no recheio',
        calories: 3650,
        restaurant: restaurant
      )

      Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Vegano'

      # Assert
      # expect(current_path).to eq restaurant_dishes_path(restaurant.id, filter:  tag.name)
      expect(page).to have_content 'Tapioca de Coco'
      expect(page).not_to have_content 'Bolo Floresta Negra'
      expect(page).not_to have_content 'Petit Gateau de Mousse Insuflado'
    end
  end
end
