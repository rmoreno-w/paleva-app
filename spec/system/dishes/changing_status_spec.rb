require 'rails_helper'

describe 'User' do
  context 'tries to inactivate a dish in the show page' do
    it 'and succeeds' do
      dish = create_dish

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Desativar Prato'

      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Inativo 🔴'
      expect(page).to have_content 'Sucesso! Prato desativado'
      expect(page).to have_button 'Ativar Prato'
    end
  end

  context 'tries to activate an inactive dish in the show page' do
    it 'and succeeds' do
      dish = create_dish
      dish.inactive!

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Ativar Prato'

      expect(current_path).to eq restaurant_dish_path(dish.restaurant.id, dish.id)
      expect(page).to have_content 'Ativo 🟢'
      expect(page).to have_content 'Sucesso! Prato ativado'
      expect(page).to have_button 'Desativar Prato'
    end
  end
end
