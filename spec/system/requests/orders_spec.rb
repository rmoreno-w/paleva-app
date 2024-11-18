require 'rails_helper'

describe 'User' do
  context 'tries to get the form to finish an order' do
    it 'but is not authenticated' do
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

      # Act
      get restaurant_new_order_path(restaurant)

      # Assert
      expect(response).to redirect_to new_user_session_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      login_as restaurant.user
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

      # Act
      get restaurant_new_order_path(second_restaurant)

      # Assert
      expect(response).to redirect_to root_path
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
      login_as restaurant.user

      # Act
      get restaurant_new_order_path(restaurant)

      # Assert
      expect(response).to have_http_status 200
    end
  end

  context 'tries to visualize the page of an order' do
    it 'but is not authenticated' do
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
      order = Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )

      # Act
      get restaurant_order_path(restaurant, order)

      # Assert
      expect(response).to redirect_to new_user_session_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      order = Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      login_as restaurant.user
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

      # Act
      get restaurant_order_path(second_restaurant, order)

      # Assert
      expect(response).to redirect_to root_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      login_as restaurant.user
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
      order_from_another_restaurant = Order.create!(
        customer_name: 'Amilton',
        customer_phone: '12999000099',
        customer_email: 'amilton@email.com',
        customer_registration_number: CPF.generate,
        restaurant: second_restaurant
      )

      # Act
      get restaurant_order_path(restaurant, order_from_another_restaurant)

      # Assert
      expect(response).to redirect_to root_path
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
      order = Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      login_as restaurant.user

      # Act
      get restaurant_order_path(restaurant, order)

      # Assert
      expect(response).to have_http_status 200
    end
  end

  context 'tries to visualize all the orders of their restaurant' do
    it 'but is not authenticated' do
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
      Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )

      # Act
      get restaurant_orders_path(restaurant)

      # Assert
      expect(response).to redirect_to new_user_session_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      login_as restaurant.user
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

      # Act
      get restaurant_orders_path(second_restaurant)

      # Assert
      expect(response).to redirect_to root_path
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
      Order.create(
        customer_name: 'Adeilson',
        customer_phone: '35999222299',
        customer_email: 'adeilson@email.com',
        customer_registration_number: CPF.generate,
        restaurant: restaurant
      )
      login_as restaurant.user

      # Act
      get restaurant_orders_path(restaurant)

      # Assert
      expect(response).to have_http_status 200
    end
  end

  context 'tries to add an item to an order of their restaurant' do
    it 'but is not authenticated' do
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
      serving = Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)


      # Act
      post restaurant_order_add_item_path(
        restaurant,
        params: {
          item_id: serving.id,
          item_set_id: item_set.id
        })


      # Assert
      expect(response).to redirect_to new_user_session_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      serving = Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user

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


      # Act
      post restaurant_order_add_item_path(
        second_restaurant,
        params: {
          item_set_id: item_set.id,
          item_id: serving.id
        })


      # Assert
      expect(response).to redirect_to root_path
    end

    it 'and fails if they provide an id of an item set they dont own' do
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
      serving = Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user

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
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: second_restaurant
      )
      serving = Serving.create!(
        description: 'Copo de 350ml',
        current_price: 8.5,
        servingable: beverage
      )
      item_set_from_another_restaurant = ItemOptionSet.create!(name: 'Café Frances', restaurant: second_restaurant)
      item_set_from_another_restaurant.item_option_entries.create!(itemable: beverage)


      # Act
      post restaurant_order_add_item_path(
        restaurant,
        params: {
          item_set_id: item_set_from_another_restaurant.id,
          item_id: serving.id
        })


      # Assert
      expect(response).to redirect_to root_path
    end

    it 'and fails if they provide an id of a serving they dont own' do
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
      Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user

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
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Caixa de 1L. Já vem gelada',
        calories: 150,
        is_alcoholic: false,
        restaurant: second_restaurant
      )
      serving_from_another_restaurant = Serving.create!(
        description: 'Copo de 350ml',
        current_price: 8.5,
        servingable: beverage
      )
      item_set_from_another_restaurant = ItemOptionSet.create!(name: 'Café Frances', restaurant: second_restaurant)
      item_set_from_another_restaurant.item_option_entries.create!(itemable: beverage)


      # Act
      post restaurant_order_add_item_path(
        restaurant,
        params: {
          item_set_id: item_set.id,
          item_id: serving_from_another_restaurant.id
        })


      # Assert
      expect(response).to redirect_to root_path
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
      serving = Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user

      # Act
      post restaurant_order_add_item_path(
        restaurant,
        params: {
          item_set_id: item_set.id,
          item_id: serving.id
        })

      # Assert
      expect(response).to redirect_to restaurant_item_option_set_path(restaurant, item_set)
    end
  end

  context 'tries to create an order of their restaurant (post request)' do
    before do
      page.driver.browser.set_cookie('paleva_session={"order":{"1":2,"2":2}}')
    end

    it 'but is not authenticated' do
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
      Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      second_dish = Dish.create!(
        name: 'Pão Francês',
        description: 'Tradicional pãozinho salgado, casquinha crocante',
        calories: 255,
        restaurant: restaurant
      )
      Serving.create!(
        description: '1 unidade',
        current_price: 0.75,
        servingable: second_dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)


      # Act
      post restaurant_orders_path(
        restaurant,
        params: {
          customer_name: 'Adeilson Filho',
          customer_reg_number: CPF.generate,
          customer_phone: '12999000099',
          customer_email: 'adeilson@email.com',
          customer_notes: [
            'Com talheres de plástico',
            'Colocar em saquinho de papel para não murchar'
          ],
          item_set_id: item_set.id
        })


      # Assert
      expect(response).to redirect_to new_user_session_path
    end

    it 'and fails if they provide an id of a restaurant they dont own' do
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
      Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      second_dish = Dish.create!(
        name: 'Pão Francês',
        description: 'Tradicional pãozinho salgado, casquinha crocante',
        calories: 255,
        restaurant: restaurant
      )
      Serving.create!(
        description: '1 unidade',
        current_price: 0.75,
        servingable: second_dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user

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


      # Act
      post restaurant_orders_path(
        second_restaurant,
        params: {
          customer_name: 'Adeilson Filho',
          customer_reg_number: CPF.generate,
          customer_phone: '12999000099',
          customer_email: 'adeilson@email.com',
          customer_notes: [
            'Com talheres de plástico',
            'Colocar em saquinho de papel para não murchar'
          ],
          item_set_id: item_set.id
        })


      # Assert
      expect(response).to redirect_to root_path
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
      Serving.create!(
        description: '1 Bolinho + 1 Bola de Sorvete',
        current_price: 24.5,
        servingable: dish
      )
      second_dish = Dish.create!(
        name: 'Pão Francês',
        description: 'Tradicional pãozinho salgado, casquinha crocante',
        calories: 255,
        restaurant: restaurant
      )
      Serving.create!(
        description: '1 unidade',
        current_price: 0.75,
        servingable: second_dish
      )
      item_set = ItemOptionSet.create!(name: 'Café Frances', restaurant: restaurant)
      item_set.item_option_entries.create!(itemable: dish)
      login_as restaurant.user


      # Act
      post restaurant_orders_path(
        restaurant,
        params: {
          customer_name: 'Adeilson Filho',
          customer_reg_number: CPF.generate,
          customer_phone: '12999000099',
          customer_email: 'adeilson@email.com',
          customer_notes: [
            'Com talheres de plástico',
            'Colocar em saquinho de papel para não murchar'
          ],
          item_set_id: item_set.id
        })


      # Assert
      expect(response).to redirect_to restaurant_orders_path(restaurant)
    end
  end
end