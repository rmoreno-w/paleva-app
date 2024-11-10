require 'rails_helper'

describe 'User' do
  context 'tries to access the listing of users (employees) they pre registered for their restaurant' do
    it 'and succeed' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

      visit root_path
      click_on 'Funcionários'

      expect(current_path).to eq restaurant_staff_members_path(restaurant)
      expect(page).to have_content 'Funcionários'
      expect(page).to have_link '+ Realizar Pré-Cadastro'
    end
  end
end
