require 'rails_helper'

describe 'User' do
  context 'tries to access the beverage creation page' do
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
      # expect(page).to have_content 'Criar Bebida'
      click_on 'Criar Bebida'

      # Assert
      expect(current_path).to eq new_restaurant_beverage_path(restaurant.id)
      expect(page).to have_content 'Criar Bebida'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Calorias'
      expect(page).to have_field 'É bebida alcoólica?'
    end
  end

  context 'is logged in, has a restaurant, and tries to create a beverage' do
    it 'and succeeds' do
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
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Criar Bebida'
      
      fill_in 'Nome', with: 'Água de coco Sócoco'
      fill_in 'Descrição', with: 'Caixa de 1L. Vem gelada'
      fill_in 'Calorias', with: '150'
      uncheck 'É bebida alcoólica'
      attach_file 'Foto da Bebida', Rails.root.join('spec', 'support', 'agua_coco.jpeg')
      click_on 'Criar Bebida'

      # Assert
      beverage = Beverage.last
      # expect(current_path).to eq restaurant_beverage_path(restaurant.id, beverage.id)
      expect(page).to have_content 'Água de coco Sócoco'
      expect(page).to have_content 'Caixa de 1L. Vem gelada'
      expect(page).to have_content '150'
      expect(page).to have_content '❌'
      expect(beverage.picture.attached?).to eq true
      expect(page).to have_css('img[src*="agua_coco.jpeg"]')
    end

    it 'and fails when informing invalid data' do
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
      click_on 'Criar Bebida'
      
      fill_in 'Nome', with: 'Água de coco Sócoco'
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: '150'
      click_on 'Criar Bebida'

      # Assert
      expect(current_path).to eq restaurant_beverages_path(restaurant.id)
      expect(page).to have_content 'Erro ao criar a bebida'
      expect(page).not_to have_content 'Água de coco Sócoco'
      expect(page).not_to have_content '378'
    end
  end
end