require 'rails_helper'

describe 'User' do
  context 'logs in as a staff member' do
    it 'and has restricted access (can only see restaurant data, visualize item sets and create orders)' do
      restaurant_owner = User.create!(
        name: 'Adeilson',
        family_name: 'Souza',
        registration_number: CPF.generate,
        email: 'adeilson@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '30.883.175/2481-06',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '12987654321',
        email: 'campus@ducodi.com.br',
        user: restaurant_owner
      )
      second_user = User.create!(
        name: 'Jacquin',
        family_name: 'DuFrance',
        registration_number: CPF.generate,
        email: 'ajc@cquin.com',
        password: 'fortissima12',
        role: :staff,
        restaurant: restaurant
      )
      login_as second_user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      dish = Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestle 150g',
        calories: 258,
        restaurant: restaurant
      )

      dish_serving = Serving.create!(
        description: 'Pequena',
        current_price: 35.5,
        servingable: dish
      )

      beverage_serving = Serving.create!(
        description: 'Grande',
        current_price: 35.5,
        servingable: beverage
      )

      tag = Tag.create(name: 'Vegano', restaurant: restaurant)
      item_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

      order = Order.create!(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      OrderItem.create!(
        item_name: dish_serving.servingable.name,
        serving_description: dish_serving.description,
        serving_price: dish_serving.current_price,
        number_of_servings: 2,
        customer_notes: 'Nota do consumidor',
        order: order
      )

      all_pages = list_pages(
        beverage: beverage,
        restaurant: restaurant,
        dish: dish,
        dish_serving: dish_serving,
        beverage_serving: beverage_serving,
        tag: tag,
        order: order,
        item_set: item_set
      )

      # Act
      allowed_pages = [
        root_path,
        restaurant_item_option_set_path(restaurant.id, item_set.id),
        new_restaurant_restaurant_operating_hour_path(restaurant.id),
        restaurant_restaurant_operating_hours_path(restaurant.id),
        restaurant_new_order_path(restaurant.id),
      ]

      # Assert
      all_pages.each do |checked_page|
        visit checked_page

        if allowed_pages.include? checked_page
          expect(current_path).to eq checked_page
        else
          expect(current_path).to eq root_path
          expect(page).to have_content 'Você não tem acesso a esta página'
        end
      end
    end
  end
end
