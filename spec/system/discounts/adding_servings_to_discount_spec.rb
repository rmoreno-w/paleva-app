require 'rails_helper'

describe 'User' do
  context 'tries to access the page to add a serving to a discount' do
    it 'but first has to be logged in' do
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
      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )

      # Act
      visit restaurant_discount_new_dish_serving_path(restaurant, discount)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
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
      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      login_as user

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana do Petit Gateau'
      click_on 'Adicionar Porção (Prato)'

      # Assert
      expect(current_path).to eq restaurant_discount_new_dish_serving_path(restaurant, discount)
    end

    it 'and adds a serving of a dish with success' do
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
      login_as user
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      serving = Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)
      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )


      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana do Petit Gateau'
      click_on 'Adicionar Porção (Prato)'
      select 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete', from: 'Porções de Pratos Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_discount_path(restaurant, discount)
      expect(page).to have_content "#{dish.name} - #{serving.description} adicionado(a) ao Desconto com sucesso!"
      expect(page).to have_content 'Itens adicionados ao Desconto:'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete'
    end

    it 'and does not see a serving of a dish that is already on the discount in the select options' do
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
      login_as user

      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      serving = Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)
      Serving.create!(description: '1 Bolinho (sem Bola de Sorvete)', current_price: 12.9, servingable: dish)
      DiscountedServing.create!(serving: serving, discount: discount)

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana do Petit Gateau'
      click_on 'Adicionar Porção (Prato)'


      # Assert
      expect(current_path).to eq restaurant_discount_new_dish_serving_path(restaurant, discount)
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho (sem Bola de Sorvete)'
      expect(page).not_to have_content 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete'
    end

    it 'and does not see a serving of a dish from another restaurant in the select options' do
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
      login_as user
      dish = Dish.create!(
        name: 'Petit Gateau de Mousse Insuflado',
        description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
        calories: 580,
        restaurant: restaurant
      )
      Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)
      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
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
      dish_from_another_restaurant = Dish.create!(
        name: 'Tortinha de Maçã',
        description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
        calories: 650,
        restaurant: second_restaurant
      )
      Serving.create!(description: 'Tamanho P - 240g', current_price: 18.9, servingable: dish_from_another_restaurant)

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana do Petit Gateau'
      click_on 'Adicionar Porção (Prato)'


      # Assert
      expect(current_path).to eq restaurant_discount_new_dish_serving_path(restaurant, discount)
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete'
      expect(page).not_to have_content 'Tortinha de Maçã --- Porção: Tamanho P - 240g'
    end
  end

  context 'tries to access the page to add a beverage to a set of item options' do
    it 'but first has to be logged in' do
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
      discount = Discount.create!(
        name: 'Semana do Petit Gateau',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )

      # Act
      visit restaurant_discount_new_beverage_serving_path(restaurant, discount)

      # Assert
      expect(current_path).to eq new_user_session_path
    end

    it 'and should land in the correct page if it has a restaurant and is logged in' do
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
      discount = Discount.create!(
        name: 'Semana da Agua de Coco',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      login_as user

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana da Agua de Coco'
      click_on 'Adicionar Porção (Bebida)'

      # Assert
      expect(current_path).to eq restaurant_discount_new_beverage_serving_path(restaurant, discount)
    end

    it 'and adds a serving of a beverage with success' do
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
      login_as user

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      discount = Discount.create!(
        name: 'Semana da Agua de Coco',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )


      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana da Agua de Coco'
      click_on 'Adicionar Porção (Bebida)'
      select 'Agua de coco Sócoco --- Porção: Garrafa 750ml', from: 'Porções de Bebidas Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_discount_path(restaurant, discount)
      expect(page).to have_content "#{beverage.name} - #{serving.description} adicionado(a) ao Desconto com sucesso!"
      expect(page).to have_content 'Itens adicionados ao Desconto:'
      expect(page).to have_content 'Agua de coco Sócoco --- Porção: Garrafa 750ml'
    end

    it 'and does not see a serving of a beverage that is already on the discount in the select options' do
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
      login_as user

      discount = Discount.create!(
        name: 'Semana da Agua de Coco',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      serving = Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      Serving.create!(description: 'Garrafa 350ml', current_price: 12.9, servingable: beverage)
      DiscountedServing.create!(serving: serving, discount: discount)

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana da Agua de Coco'
      click_on 'Adicionar Porção (Bebida)'


      # Assert
      expect(current_path).to eq restaurant_discount_new_beverage_serving_path(restaurant, discount)
      expect(page).to have_content 'Agua de coco Sócoco --- Porção: Garrafa 350ml'
      expect(page).not_to have_content 'Agua de coco Sócoco --- Porção: Garrafa 750ml'
    end

    it 'and does not see a serving of a beverage from another restaurant in the select options' do
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
      login_as user

      discount = Discount.create!(
        name: 'Semana da Agua de Coco',
        percentage: 15,
        start_date: 1.week.from_now.to_fs(:db).split(' ').first,
        end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
        limit_of_uses: 100, 
        restaurant: restaurant
      )
      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)

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
      beverage_from_another_restaurant = Beverage.create!(
        name: 'Coca Cola Cherry',
        description: 'Zero Açucar',
        calories: 7,
        restaurant: second_restaurant
      )
      Serving.create!(description: 'Garrafa 350ml', current_price: 12.5, servingable: beverage_from_another_restaurant)

      # Act
      visit root_path
      click_on 'Descontos'
      click_on 'Semana da Agua de Coco'
      click_on 'Adicionar Porção (Bebida)'


      # Assert
      expect(current_path).to eq restaurant_discount_new_beverage_serving_path(restaurant, discount)
      expect(page).to have_content 'Agua de coco Sócoco --- Porção: Garrafa 750ml'
      expect(page).not_to have_content 'Coca Cola Cherry --- Porção: Garrafa 350ml'
    end
  end
end