require 'rails_helper'

describe 'User' do
  context 'tries to assign a tag to a dish' do
    it 'and finds the button to do so on a dish page' do
      dish = create_dish

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      
      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      within '#tags' do
        expect(page).to have_link '+'
      end
    end

    it 'and only sees tags from its own restaurant' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      dish.tags << Tag.create!(name: 'Sem Açucar', restaurant: dish.restaurant)
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
      Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)

      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      expect(dish.tags.count).to eq 2
      within '#tags' do
        expect(page).to have_content 'Vegano'
        expect(page).to have_content 'Sem Açucar'
        expect(page).not_to have_content 'Sobremesa'
        expect(page).to have_selector 'li', count: 2
      end
    end

    it 'and canot add/see a tag to a dish that it already owns' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on '+'

      # Assert
      expect(current_path).to eq restaurant_dish_new_tag_assignment_path(dish.restaurant, dish)
      expect(page).not_to have_content 'Vegano'
      expect(page).to have_content 'Não há Tags disponíveis ou todas Tags já foram assignadas a este prato'
    end

    it 'and succeeds' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      within '#tags' do
        click_on '+'
      end
      select 'Vegano', from: 'Tags Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      expect(page).to have_content 'Vegano'
    end
  end

  context 'tries to unassign a tag from a dish' do
    it 'and doesnt find the button to do so on a dish page, if it doesnt have a tag assigned' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      within '#tags' do
        expect(page).not_to have_link '-'
      end
    end

    it 'and finds the button to do so on a dish page, if it has a tag assigned' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      expect(page).to have_content 'Vegano'
      expect(page).to have_link '-'
    end

    it 'and finds only tags assigned to the dish on the form' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      Tag.create!(name: 'Sem Açucar', restaurant: dish.restaurant)
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
      Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on '-'

      # Assert
      expect(current_path).to eq restaurant_dish_remove_tag_assignment_path(dish.restaurant, dish)
      expect(dish.tags.count).to eq 1
      expect(page).to have_selector 'option', count: 1
      expect(page).to have_content 'Vegano'
      expect(page).not_to have_content 'Sem Açucar'
      expect(page).not_to have_content 'Sobremesa'
    end

    it 'and succeeds' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      dish.tags << Tag.create!(name: 'Sem Açucar', restaurant: dish.restaurant)
      login_as dish.restaurant.user

      # Act
      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on '-'
      select 'Vegano', from: 'Tags Disponíveis'
      click_on 'Remover'

      # Assert
      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      expect(dish.tags.count).to eq 1
      expect(page).not_to have_content 'Vegano'
      expect(page).to have_content 'Sem Açucar'
    end
  end
end
