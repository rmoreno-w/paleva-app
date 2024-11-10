require 'rails_helper'

describe 'User' do
  context 'tries to create a pre-registration of an users (employees) for their restaurant' do
    it 'and succeed' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

      visit root_path
      click_on 'Funcionários'
      click_on '+ Realizar Pré-Cadastro'
      fill_in 'E-mail', with: 'valente@email.com'
      fill_in 'CPF', with: CPF.generate
      click_on 'Cadastrar'

      pre_regiter = PreRegistration.last
      expect(current_path).to eq restaurant_staff_members_path(restaurant)
      expect(page).to have_content 'Funcionários'
      # expect(page).to have_content 'Aqui você faz um pré-registro de seu funcionário, informando alguns dados. Assim que ele se cadastrar na plataforma, nosso sistema reconhece automaticamente e o associa a seu Restaurante! :)'
      expect(page).to have_content 'valente@email.com'
      expect(page).to have_content "#{pre_regiter.registration_number}"
    end
  end
end
