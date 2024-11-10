require 'rails_helper'

describe 'User' do
  context 'tries to inactivate a beverage in the show page' do
    it 'and succeeds' do
      beverage = create_beverage

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Desativar Bebida'

      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Inativo 🔴'
      expect(page).to have_content 'Sucesso! Bebida desativada'
      expect(page).to have_button 'Ativar Bebida'
    end
  end

  context 'tries to activate an inactive beverage in the show page' do
    it 'and succeeds' do
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
        registration_number: CNPJ.generate,
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )
      # puts "ALOW #{restaurant.user.id} "
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      beverage.inactive!
      # puts user.restaurant.inspect
      # puts restaurant.user.inspect

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Ativar Bebida'

      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant.id, beverage.id)
      expect(page).to have_content 'Ativo 🟢'
      expect(page).to have_content 'Sucesso! Bebida ativada'
      expect(page).to have_button 'Desativar Bebida'
    end
  end
end
