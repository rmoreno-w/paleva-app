require 'rails_helper'

describe 'User' do
  context 'tries to edit a serving for a dish' do
    it 'but has to first be logged in' do
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
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)', current_price: 24.5, servingable: dish)

      visit edit_restaurant_dish_serving_path(dish.restaurant, dish, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)'
      expect(page).not_to have_content '24,50'
    end

    it 'and gets the correct page' do
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
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)', current_price: 24.5, servingable: dish)
      login_as dish.restaurant.user

      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Editar'

      expect(current_path).to eq edit_restaurant_dish_serving_path(dish.restaurant, dish, serving)
      expect(page).to have_selector 'h2', text: 'Editar Porção'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço Atual'
      expect(page).to have_button 'Atualizar Porção'
    end

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
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: user
      )
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)', current_price: 24.5, servingable: dish)
      login_as dish.restaurant.user

      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Editar'
      fill_in 'Preço Atual', with: '36.50'
      click_on 'Atualizar Porção'

      expect(current_path).to eq restaurant_dish_path(dish.restaurant, dish)
      expect(page).to have_content 'Porção Individual (1 Bolinho e 1 Bola de Sorvete) - R$ 36,50'
      expect(page).to have_content 'Porção atualizada com sucesso!'
    end
  end

  context 'tries to edit a serving for a beverage' do
    it 'but has to first be logged in' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa 1L', current_price: 24.5, servingable: beverage)

      visit edit_restaurant_beverage_serving_path(beverage.restaurant, beverage, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content 'Garrafa 1L'
      expect(page).not_to have_content '24,50'
    end

    it 'and gets the correct page' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa de 1L', current_price: 12.5, servingable: beverage)
      login_as beverage.restaurant.user

      visit root_path
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Editar'

      expect(current_path).to eq edit_restaurant_beverage_serving_path(beverage.restaurant, beverage, serving)
      expect(page).to have_selector 'h2', text: 'Editar Porção'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço Atual'
      expect(page).to have_button 'Atualizar Porção'
    end

    it 'and succeeds' do
      beverage = create_beverage
      Serving.create!(description: 'Garrafa de 1L', current_price: 12.5, servingable: beverage)
      login_as beverage.restaurant.user

      visit root_path
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Editar'
      fill_in 'Preço Atual', with: '10.50'
      click_on 'Atualizar Porção'

      expect(current_path).to eq restaurant_beverage_path(beverage.restaurant, beverage)
      expect(page).to have_content 'Garrafa de 1L - R$ 10,50'
      expect(page).to have_content 'Porção atualizada com sucesso!'
    end
  end
end
