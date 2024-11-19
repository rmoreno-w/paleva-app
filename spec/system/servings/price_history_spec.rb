require 'rails_helper'

describe 'User' do
  context 'tries to see the price history of a serving for a dish' do
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
      serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)

      visit restaurant_dish_serving_history_path(dish.restaurant, dish, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content '1 Bolinho'
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
      login_as user

      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Histórico'

      expect(current_path).to eq restaurant_dish_serving_history_path(dish.restaurant, dish, serving)
      expect(page).to have_selector 'h2', text: "Histórico de Preços para #{dish.name} # Porção - #{serving.description}"
      expect(page).to have_content 'Data de Alteração'
      expect(page).to have_content 'Preço'
      expect(page).to have_content I18n.l(serving.price_history[0].change_date, format: :long_date)
      expect(page).to have_content '24,50'
    end

    it 'and succeeds, seeing the history of prices for that item' do
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
      serving.current_price = 25.5
      serving.current_price = 31.98
      login_as user

      visit root_path
      click_on 'Pratos'
      click_on 'Petit Gateau de Mousse Insuflado'
      click_on 'Histórico'

      price_history = serving.price_history
      expect(current_path).to eq restaurant_dish_serving_history_path(dish.restaurant, dish, serving)
      expect(page).to have_content 'Data de Alteração'
      expect(page).to have_content 'Preço'
      price_history.each do |price_record|
        expect(page).to have_content I18n.l(price_record.change_date, format: :long_date)
        expect(page).to have_content price_record.price.to_s.sub('.', ',')
      end
    end
  end

  context 'tries to see the price history of a serving for a beverage' do
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
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Garrafa 1L', current_price: 24.5, servingable: beverage)

      visit restaurant_beverage_serving_history_path(beverage.restaurant, beverage, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content 'Garrafa 1L'
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
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Garrafa Individual', current_price: 2.5, servingable: beverage)
      login_as user

      visit root_path
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Histórico'

      expect(current_path).to eq restaurant_beverage_serving_history_path(beverage.restaurant, beverage, serving)
      expect(page).to have_selector 'h2', text: "Histórico de Preços para #{beverage.name} # Porção - #{serving.description}"
      expect(page).to have_content 'Data de Alteração'
      expect(page).to have_content 'Preço'
      expect(page).to have_content I18n.l(serving.price_history[0].change_date, format: :long_date)
      expect(page).to have_content '2,50'
    end

    it 'and succeeds, seeing the history of prices for that item' do
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
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Garrafa Individual', current_price: 2.5, servingable: beverage)
      serving.current_price = 3.5
      serving.save
      serving.current_price = 5.92
      serving.save
      
      login_as user

      visit root_path
      click_on 'Bebidas'
      click_on 'Agua de coco Sócoco'
      click_on 'Histórico'

      price_history = serving.price_history
      expect(current_path).to eq restaurant_beverage_serving_history_path(beverage.restaurant, beverage, serving)
      expect(page).to have_content 'Data de Alteração'
      expect(page).to have_content 'Preço'
      price_history.each do |price_record|
        expect(page).to have_content I18n.l(price_record.change_date, format: :long_date)
        expect(page).to have_content price_record.price.to_s.sub('.', ',')
      end
    end
  end
end
