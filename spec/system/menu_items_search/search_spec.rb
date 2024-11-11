require 'rails_helper'

describe 'User' do
  context 'tries to fill in the search form' do
    it 'but should only see it if is logged in' do
      visit root_path

      expect(page).not_to have_content 'Procurar no Menu'
      expect(page).not_to have_selector 'input[placeholder="Digite nome ou descrição de um prato ou bebida"]'
    end

    it 'and is not able to find the search field if it has no restaurant' do
      user = create_user
      login_as user

      visit root_path

      expect(page).not_to have_content 'Procurar no Menu'
      expect(page).not_to have_selector 'input[placeholder="Ex: Pizza, Caipirinha..."]'
    end

    it 'and is able to find the search field in the navigation bar if it already has a restaurant' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

      visit root_path

      expect(page).to have_content 'Procurar no Menu'
      expect(page).to have_selector 'input[placeholder="Ex: Pizza, Caipirinha..."]'
    end

    it 'and makes a successful search' do
      restaurant = create_restaurant_and_user

      Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      Beverage.create!(
        name: 'Whisky Jack Daniels Honey',
        description: 'Garrafa de 750 ml',
        calories: 898,
        is_alcoholic: true,
        restaurant: restaurant
      )

      Dish.create!(
          name: 'Sufflair',
          description: 'Chocolate Nestlé 150g',
          calories: 350,
          restaurant: restaurant
        )

      login_as restaurant.user
      visit root_path
      within '#menu-search' do
        fill_in 'Procurar no Menu', with: 'f'
        click_on 'Buscar'
      end

      dish = Dish.last
      first_beverage = Beverage.first
      last_beverage = Beverage.last

      expect(page).to have_content 'Resultados da busca por: f'
      expect(page).to have_content 'Sufflair'
      expect(page).to have_content 'Whisky Jack Daniels Honey'
      expect(page).to have_content I18n.t(dish.status)
      expect(page).to have_content I18n.t(first_beverage.status)
      expect(page).to have_content I18n.t(last_beverage.status)
      expect(page).not_to have_content 'Agua de coco Sócoco'

    end

    it 'and sees a link to see details of an item' do
      restaurant = create_restaurant_and_user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      dish = Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestlé 150g',
        calories: 350,
        restaurant: restaurant
      )

      login_as restaurant.user
      visit root_path
      fill_in 'Procurar no Menu', with: 'a'
      click_on 'Buscar'

      expect(page).to have_content 'Resultados da busca por: a'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_link 'Ver detalhes', href: restaurant_beverage_path(restaurant, beverage)
      expect(page).to have_content 'Sufflair'
      expect(page).to have_link 'Ver detalhes', href: restaurant_dish_path(restaurant, dish)
    end

    it 'and sees a link to edit an item' do
      restaurant = create_restaurant_and_user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      dish = Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestlé 150g',
        calories: 350,
        restaurant: restaurant
      )

      login_as restaurant.user
      visit root_path
      fill_in 'Procurar no Menu', with: 'a'
      click_on 'Buscar'

      expect(page).to have_content 'Resultados da busca por: a'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_link 'Editar', href: edit_restaurant_beverage_path(restaurant, beverage)
      expect(page).to have_content 'Sufflair'
      expect(page).to have_link 'Editar', href: edit_restaurant_dish_path(restaurant, dish)
    end

    it 'and sees a message when there are no items found' do
      restaurant = create_restaurant_and_user
      search_query = 'a'

      login_as restaurant.user
      visit root_path
      fill_in 'Procurar no Menu', with: search_query
      click_on 'Buscar'

      expect(page).to have_content 'Resultados da busca por: a'
      expect(page).to have_content "Nenhum resultado encontrado na busca por bebidas e pratos com \"#{search_query}\""
    end

    it 'and sees a list with all the dishes and beverages when the query is blank' do
      restaurant = create_restaurant_and_user

      Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestle 150g',
        calories: 258,
        restaurant: restaurant
      )

      Dish.create!(
        name: 'Pacote de Bala 7 Belo',
        description: 'Pacote de 150 unidades. Peso 700g',
        calories: 3650,
        restaurant: restaurant
      )

      login_as restaurant.user
      visit root_path
      fill_in 'Procurar no Menu', with: ''
      click_on 'Buscar'

      expect(page).to have_content 'Resultados da busca por:'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Sufflair'
      expect(page).to have_content 'Pacote de Bala 7 Belo'
    end

    it 'and doesnt see items from other users' do
      restaurant = create_restaurant_and_user

      Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )

      Dish.create!(
        name: 'Sufflair',
        description: 'Chocolate Nestle 150g',
        calories: 258,
        restaurant: restaurant
      )

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

      Beverage.create!(
        name: 'Whisky Jack Daniels Honey',
        description: 'Garrafa de 750 ml',
        calories: 898,
        is_alcoholic: true,
        restaurant: second_restaurant
      )

      Dish.create!(
        name: 'Bala 7 Belo',
        description: '150 unidades. Peso 700g',
        calories: 3650,
        restaurant: second_restaurant
      )

      login_as restaurant.user
      visit root_path
      fill_in 'Procurar no Menu', with: 'c'
      click_on 'Buscar'

      expect(page).to have_content 'Resultados da busca por: c'
      expect(page).to have_content 'Agua de coco Sócoco'
      expect(page).to have_content 'Sufflair'
      expect(page).not_to have_content 'Bala 7 Belo'
      expect(page).not_to have_content 'Whisky Jack Daniels Honey'
    end

    it 'and is able to find the search field in the navigation bar in any page thath needs login and a restaurant - If it already has a restaurant' do
      restaurant = create_restaurant_and_user
      login_as restaurant.user

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

      pages = list_pages(
        beverage: beverage,
        restaurant: restaurant,
        dish: dish,
        dish_serving: dish_serving,
        beverage_serving: beverage_serving,
        tag: tag,
        order: order,
        item_set: item_set
      )

      pages.each do |page_url|
        visit page_url

        expect(page).to have_content 'Procurar no Menu'
        expect(page).to have_selector 'input[placeholder="Ex: Pizza, Caipirinha..."]'
      end
    end
  end
end
