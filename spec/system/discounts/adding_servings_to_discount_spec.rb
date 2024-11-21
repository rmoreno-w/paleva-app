require 'rails_helper'

describe 'User' do
  context 'tries to access the page to add a serving to a discount' do
    # it 'but first has to be logged in' do
    #   user = User.create!(
    #     name: 'Aloisio',
    #     family_name: 'Silveira',
    #     registration_number: '08000661110',
    #     email: 'aloisio@email.com',
    #     password: 'fortissima12'
    #   )
    #   restaurant = Restaurant.create!(
    #     brand_name: 'Pizzaria Campus du Codi',
    #     corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    #     registration_number: '30.883.175/2481-06',
    #     address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    #     phone: '12987654321',
    #     email: 'campus@ducodi.com.br',
    #     user: user
    #   )
    #   option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

    #   # Act
    #   visit restaurant_item_option_set_new_dish_path(restaurant, option_set)

    #   # Assert
    #   expect(current_path).to eq new_user_session_path
    # end

    # it 'and should land in the correct page if it has a restaurant and is logged in' do
    #   user = User.create!(
    #     name: 'Aloisio',
    #     family_name: 'Silveira',
    #     registration_number: '08000661110',
    #     email: 'aloisio@email.com',
    #     password: 'fortissima12'
    #   )
    #   restaurant = Restaurant.create!(
    #     brand_name: 'Pizzaria Campus du Codi',
    #     corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    #     registration_number: '30.883.175/2481-06',
    #     address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    #     phone: '12987654321',
    #     email: 'campus@ducodi.com.br',
    #     user: user
    #   )
    #   option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)
    #   login_as user

    #   # Act
    #   visit root_path
    #   click_on 'Almoço'
    #   click_on 'Adicionar Prato'

    #   # Assert
    #   expect(current_path).to eq restaurant_item_option_set_new_dish_path(restaurant, option_set)
    #   expect(page).to have_selector 'h2', text: "Adicionar Prato a #{option_set.name}"
    # end

    # it 'and should not see a link to add a dish to the item set if they are a staff member' do
    #   user = User.create!(
    #     name: 'Aloisio',
    #     family_name: 'Silveira',
    #     registration_number: '08000661110',
    #     email: 'aloisio@email.com',
    #     password: 'fortissima12'
    #   )
    #   restaurant = Restaurant.create!(
    #     brand_name: 'Pizzaria Campus du Codi',
    #     corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    #     registration_number: '30.883.175/2481-06',
    #     address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    #     phone: '12987654321',
    #     email: 'campus@ducodi.com.br',
    #     user: user
    #   )
    #   item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
    #   User.create!(
    #     name: 'Adeilson',
    #     family_name: 'Gomes',
    #     registration_number: CPF.generate(),
    #     email: 'adeilson@email.com',
    #     password: 'fortissima12',
    #     restaurant: restaurant,
    #     role: :staff
    #   )

    #   # Act
    #   visit root_path
    #   click_on 'Entrar'
    #   fill_in 'E-mail', with: 'adeilson@email.com'
    #   fill_in 'Senha', with: 'fortissima12'
    #   click_on 'Entrar'
    #   click_on 'Café da Tarde'

    #   # Assert
    #   expect(current_path).to eq restaurant_item_option_set_path(restaurant, item_set)
    #   expect(page).not_to have_link 'Adicionar Prato ao Cardápio'
    # end

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

      beverage = Beverage.create!(
        name: 'Agua de coco Sócoco',
        description: 'Extraída de coco à vacuo, pasteurizada',
        calories: 150,
        is_alcoholic: false,
        restaurant: restaurant
      )
      Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      dish = Dish.new(
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
      click_on 'Adicionar Porção (Pratos)'
      select 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete', from: 'Porções de Pratos Disponíveis'
      click_on 'Adicionar'

      # Assert
      expect(current_path).to eq restaurant_discount_path(restaurant, discount)
      expect(page).to have_content "#{dish.name} - #{serving.description} adicionado(a) ao Desconto com sucesso!"
      expect(page).to have_content 'Itens adicionados ao Desconto:'
      expect(page).to have_content 'Petit Gateau de Mousse Insuflado --- Porção: 1 Bolinho + 1 Bola de Sorvete'
    end

  #   it 'and does not see a dish that is already on the set in the select options' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     login_as user

  #     beverage = Beverage.create!(
  #       name: 'Agua de coco Sócoco',
  #       description: 'Extraída de coco à vacuo, pasteurizada',
  #       calories: 150,
  #       is_alcoholic: false,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
  #     dish = Dish.new(
  #       name: 'Petit Gateau de Mousse Insuflado',
  #       description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
  #       calories: 580,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)

  #     Dish.create!(
  #       name: 'Tortinha de Maçã',
  #       description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
  #       calories: 650,
  #       restaurant: restaurant
  #     )

  #     # Act
  #     visit root_path
  #     click_on 'Café da Tarde'
  #     click_on 'Adicionar Prato ao Cardápio'


  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_new_dish_path(restaurant.id, item_set.id)
  #     expect(page).to have_content 'Tortinha de Maçã'

  #     expect(page).not_to have_content 'Petit Gateau de Mousse Insuflado'
  #   end

  #   it 'and does not see a dish from another restaurant in the select options' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     login_as user
  #     Dish.create!(
  #       name: 'Petit Gateau de Mousse Insuflado',
  #       description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
  #       calories: 580,
  #       restaurant: restaurant
  #     )

  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

  #     second_user = User.create!(
  #       name: 'Jacquin',
  #       family_name: 'DuFrance',
  #       registration_number: CPF.generate,
  #       email: 'ajc@cquin.com',
  #       password: 'fortissima12'
  #     )
  #     second_restaurant = Restaurant.create!(
  #       brand_name: 'Boulangerie JQ',
  #       corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
  #       registration_number: CNPJ.generate,
  #       address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
  #       phone: '12988774532',
  #       email: 'atendimento@bjq.com.br',
  #       user: second_user
  #     )
  #     Dish.create!(
  #       name: 'Tortinha de Maçã',
  #       description: 'Tortinha de massa folhada com recheio de Geléia de Maçã e Canela',
  #       calories: 650,
  #       restaurant: second_restaurant
  #     )

  #     # Act
  #     visit root_path
  #     click_on 'Café da Tarde'
  #     click_on 'Adicionar Prato ao Cardápio'


  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_new_dish_path(restaurant.id, item_set.id)
  #     expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
      
  #     expect(page).not_to have_content 'Tortinha de Maçã'
  #   end
  # end

  # context 'tries to access the page to add a beverage to a set of item options' do
  #   it 'but first has to be logged in' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

  #     # Act
  #     visit restaurant_item_option_set_new_beverage_path(restaurant, option_set)

  #     # Assert
  #     expect(current_path).to eq new_user_session_path
  #   end

  #   it 'and should land in the correct page if it has a restaurant and is logged in' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     option_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)
  #     login_as user

  #     # Act
  #     visit root_path
  #     click_on 'Almoço'
  #     click_on 'Adicionar Bebida'

  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_new_beverage_path(restaurant, option_set)
  #     expect(page).to have_selector 'h2', text: "Adicionar Bebida a #{option_set.name}"
  #   end

  #   it 'and should not see a link to add a dish to the item set if they are a staff member' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
  #     User.create!(
  #       name: 'Adeilson',
  #       family_name: 'Gomes',
  #       registration_number: CPF.generate(),
  #       email: 'adeilson@email.com',
  #       password: 'fortissima12',
  #       restaurant: restaurant,
  #       role: :staff
  #     )

  #     # Act
  #     visit root_path
  #     click_on 'Entrar'
  #     fill_in 'E-mail', with: 'adeilson@email.com'
  #     fill_in 'Senha', with: 'fortissima12'
  #     click_on 'Entrar'
  #     click_on 'Café da Tarde'

  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_path(restaurant, item_set)
  #     expect(page).not_to have_link 'Adicionar Bebida ao Cardápio'
  #   end

  #   it 'and adds a beverage to a set of item options with success' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     login_as user

  #     beverage = Beverage.create!(
  #       name: 'Agua de coco Sócoco',
  #       description: 'Extraída de coco à vacuo, pasteurizada',
  #       calories: 150,
  #       is_alcoholic: false,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
  #     dish = Dish.new(
  #       name: 'Petit Gateau de Mousse Insuflado',
  #       description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
  #       calories: 580,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)

  #     beverage_to_be_added_to_the_set = Beverage.create!(
  #       name: 'Coca Cola',
  #       description: 'Zero Açúcar',
  #       calories: 7,
  #       is_alcoholic: false,
  #       restaurant: restaurant
  #     )
  #     beverage_to_be_added_to_the_set.servings.create(description: 'Garrafa 600ml', current_price: 4.9)


  #     # Act
  #     visit root_path
  #     click_on 'Café da Tarde'
  #     click_on 'Adicionar Bebida ao Cardápio'
  #     select 'Coca Cola', from: 'Bebidas Disponíveis'
  #     click_on 'Adicionar'

  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_path(restaurant.id, item_set.id)
  #     expect(page).to have_content "Bebida #{beverage_to_be_added_to_the_set.name} adicionada ao Cardápio com sucesso!"
  #     expect(page).to have_content 'Agua de coco Sócoco'
  #     expect(page).to have_content 'R$ 12,50'
  #     expect(page).to have_content 'Petit Gateau de Mousse Insuflado'
  #     expect(page).to have_content 'R$ 18,90'
  #     expect(page).to have_content 'Coca Cola'
  #     expect(page).to have_content 'R$ 4,90'
  #   end

  #   it 'and does not see a beverage that is already on the set in the select options' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     login_as user

  #     beverage = Beverage.create!(
  #       name: 'Agua de coco Sócoco',
  #       description: 'Extraída de coco à vacuo, pasteurizada',
  #       calories: 150,
  #       is_alcoholic: false,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
  #     dish = Dish.new(
  #       name: 'Petit Gateau de Mousse Insuflado',
  #       description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
  #       calories: 580,
  #       restaurant: restaurant
  #     )
  #     Serving.create!(description: '1 Bolinho + 1 Bola de Sorvete', current_price: 18.9, servingable: dish)

  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: dish)
  #     item_set.item_option_entries << ItemOptionEntry.new(itemable: beverage)

  #     Beverage.create!(
  #       name: 'Coca Cola',
  #       description: 'Zero Açucar',
  #       calories: 7,
  #       restaurant: restaurant
  #     )

  #     # Act
  #     visit root_path
  #     click_on 'Café da Tarde'
  #     click_on 'Adicionar Bebida ao Cardápio'


  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_new_beverage_path(restaurant.id, item_set.id)
  #     expect(page).to have_content 'Coca Cola'

  #     expect(page).not_to have_content 'Agua de coco Sócoco'
  #   end

  #   it 'and does not see a beverage from another restaurant in the select options' do
  #     user = User.create!(
  #       name: 'Aloisio',
  #       family_name: 'Silveira',
  #       registration_number: '08000661110',
  #       email: 'aloisio@email.com',
  #       password: 'fortissima12'
  #     )
  #     restaurant = Restaurant.create!(
  #       brand_name: 'Pizzaria Campus du Codi',
  #       corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  #       registration_number: '30.883.175/2481-06',
  #       address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  #       phone: '12987654321',
  #       email: 'campus@ducodi.com.br',
  #       user: user
  #     )
  #     login_as user
  #     Beverage.create!(
  #       name: 'Agua de coco Sócoco',
  #       description: 'Extraída de coco à vacuo, pasteurizada',
  #       calories: 150,
  #       is_alcoholic: false,
  #       restaurant: restaurant
  #     )

  #     item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)

  #     second_user = User.create!(
  #       name: 'Jacquin',
  #       family_name: 'DuFrance',
  #       registration_number: CPF.generate,
  #       email: 'ajc@cquin.com',
  #       password: 'fortissima12'
  #     )
  #     second_restaurant = Restaurant.create!(
  #       brand_name: 'Boulangerie JQ',
  #       corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
  #       registration_number: CNPJ.generate,
  #       address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
  #       phone: '12988774532',
  #       email: 'atendimento@bjq.com.br',
  #       user: second_user
  #     )
  #     Beverage.create!(
  #       name: 'Coca Cola',
  #       description: 'Zero Açucar',
  #       calories: 7,
  #       restaurant: second_restaurant
  #     )

  #     # Act
  #     visit root_path
  #     click_on 'Café da Tarde'
  #     click_on 'Adicionar Bebida ao Cardápio'


  #     # Assert
  #     expect(current_path).to eq restaurant_item_option_set_new_beverage_path(restaurant.id, item_set.id)
  #     expect(page).to have_content 'Agua de coco Sócoco'
      
  #     expect(page).not_to have_content 'Coca Cola'
  #   end
  end
end