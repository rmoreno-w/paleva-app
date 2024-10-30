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
      expect(page).to have_button 'Ativar Bebida'
    end
  end

  context 'tries to activate an inactive beverage in the show page' do
    it 'and succeeds' do
      beverage = create_beverage
      beverage.inactive!

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
      expect(page).to have_button 'Desativar Bebida'
    end
  end
end
