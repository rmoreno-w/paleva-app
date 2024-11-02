require 'rails_helper'

describe 'User' do
  context 'tries to see the price history of a serving for a dish' do
    it 'but has to first be logged in' do
      dish = create_dish
      serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)

      visit restaurant_dish_serving_history_path(dish.restaurant, dish, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content '1 Bolinho'
      expect(page).not_to have_content '24,50'
    end

    it 'and gets the correct page' do
      dish = create_dish
      serving = Serving.create!(description: 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)', current_price: 24.5, servingable: dish)
      login_as dish.restaurant.user

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

    it 'and succeeds, seeing the history when there is more than one record' do
      dish = create_dish
      serving = Serving.create!(description: 'Porção Individual (1 Bolinho e 1 Bola de Sorvete)', current_price: 24.5, servingable: dish)
      serving.current_price = 25.5
      serving.current_price = 31.98
      login_as dish.restaurant.user

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
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa 1L', current_price: 24.5, servingable: beverage)

      visit restaurant_beverage_serving_history_path(beverage.restaurant, beverage, serving)

      expect(current_path).to eq new_user_session_path
      expect(page).not_to have_content 'Faça seu Login'
      expect(page).not_to have_content 'Garrafa 1L'
      expect(page).not_to have_content '24,50'
    end

    it 'and gets the correct page' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa Individual', current_price: 2.5, servingable: beverage)
      login_as beverage.restaurant.user

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

    it 'and succeeds, seeing the history when there is more than one record' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa Individual', current_price: 2.5, servingable: beverage)
      serving.current_price = 3.5
      serving.save
      serving.current_price = 5.92
      serving.save
      
      login_as beverage.restaurant.user

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
