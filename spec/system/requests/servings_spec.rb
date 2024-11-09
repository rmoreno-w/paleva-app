require 'rails_helper'

describe 'User' do
  context 'creates a serving' do
    context 'for a Dish' do
      it 'but is not authenticated' do
        dish = create_dish
        serving = Serving.new(description: '1 Bolinho', current_price: 24.5, servingable: dish)

        post(
          restaurant_dish_servings_path(dish.restaurant, dish), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to new_user_session_path
      end

      it 'but fails to get to the page for providing an id for a restaurant that they dont own' do
        dish = create_dish
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
        login_as dish.restaurant.user

        get(new_restaurant_dish_serving_path(second_restaurant, dish))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a dish that they dont own' do
        dish = create_dish
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
        login_as second_user

        get(new_restaurant_dish_serving_path(second_restaurant, dish))

        expect(response.status).to redirect_to root_path
      end

      it 'with success' do
        dish = create_dish
        serving = Serving.new(description: '1 Bolinho', current_price: 24.5, servingable: dish)
        login_as dish.restaurant.user

        post(
          restaurant_dish_servings_path(dish.restaurant, dish), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        serving = Serving.last
        expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
      end

      it 'but fails for providing a restaurant that they dont own' do
        dish = create_dish
        serving = Serving.new(description: '1 Bolinho', current_price: 24.5, servingable: dish)
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
        login_as dish.restaurant.user

        post(
          restaurant_dish_servings_path(second_restaurant, dish), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        serving = Serving.last
        expect(response.status).to redirect_to root_path
      end

      it 'but fails for providing a dish that they dont own' do
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
        serving = Serving.new(description: '1 Bolinho', current_price: 24.5, servingable: dish)
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
        login_as user

        post(
          restaurant_dish_servings_path(second_restaurant, dish), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response.status).to redirect_to root_path
      end

      it 'but fails for providing invalid data' do
        dish = create_dish
        serving = Serving.new(description: '', current_price: 24.5, servingable: dish)
        login_as dish.restaurant.user

        post(
          restaurant_dish_servings_path(dish.restaurant, dish), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response.status).to eq 422
      end
    end

    context 'for a Beverage' do
      it 'but is not authenticated' do
        beverage = create_beverage
        serving = Serving.new(description: 'Garrafa 1L', current_price: 24.5, servingable: beverage)

        post(
          restaurant_beverage_servings_path(beverage.restaurant, beverage), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to new_user_session_path
      end

      it 'but fails to get to the page for providing an id for a restaurant that they dont own' do
        beverage = create_beverage
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
        login_as beverage.restaurant.user

        get(new_restaurant_beverage_serving_path(second_restaurant, beverage))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a beverage that they dont own' do
        beverage = create_beverage
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
        login_as second_user

        get(new_restaurant_beverage_serving_path(second_restaurant, beverage))

        expect(response.status).to redirect_to root_path
      end

      it 'with success' do
        beverage = create_beverage
        serving = Serving.new(description: 'Garrafa 1L', current_price: 24.5, servingable: beverage)
        login_as beverage.restaurant.user

        post(
          restaurant_beverage_servings_path(beverage.restaurant, beverage), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        serving = Serving.last
        expect(response.status).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
      end

      it 'but fails for providing invalid data' do
        beverage = create_beverage
        serving = Serving.new(description: '', current_price: 24.5, servingable: beverage)
        login_as beverage.restaurant.user

        post(
          restaurant_beverage_servings_path(beverage.restaurant, beverage), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response.status).to eq 422
      end
    end
  end

  context 'edits a serving' do
    context 'for a Dish' do
      it 'but is not authenticated' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)

        patch(
          restaurant_dish_serving_path(dish.restaurant, dish, serving), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to new_user_session_path
      end

      it 'but fails to get to the page for providing an id for a restaurant that they dont own' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)
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
        login_as dish.restaurant.user

        get(edit_restaurant_dish_serving_path(second_restaurant, dish, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a dish that they dont own' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)
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
        second_dish = Dish.create!(
          name: 'Bolo de Cenoura',
          description: 'Bolo integral feito com Farinha Láctea ®',
          calories: 387,
          restaurant: second_restaurant
        )
        login_as dish.restaurant.user

        get(edit_restaurant_dish_serving_path(dish.restaurant, second_dish, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a serving that they dont own' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 12.80, servingable: dish)
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
        second_dish = Dish.create!(
          name: 'Bolo de Cenoura',
          description: 'Bolo integral feito com Farinha Láctea ®',
          calories: 387,
          restaurant: second_restaurant
        )
        Serving.create!(description: '1 pedaço 85 g, sem cobertura', current_price: 9.80, servingable: second_dish)
        login_as second_user

        get(edit_restaurant_dish_serving_path(second_restaurant, second_dish, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'with success' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)
        login_as dish.restaurant.user

        patch(
          restaurant_dish_serving_path(dish.restaurant, dish, serving), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to restaurant_dish_path(dish.restaurant, dish)
      end

      it 'but fails for providing invalid data' do
        dish = create_dish
        serving = Serving.create!(description: '1 Bolinho', current_price: 24.5, servingable: dish)
        login_as dish.restaurant.user

        patch(
          restaurant_dish_serving_path(dish.restaurant, dish, serving), 
          params: { 
            serving: { 
              description: '',
              current_price: serving.current_price,
            }
          }
        )

        expect(response.status).to eq 422
      end
    end

    context 'for a Beverage' do
      it 'but is not authenticated' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 24.5, servingable: beverage)

        patch(
          restaurant_beverage_serving_path(beverage.restaurant, beverage, serving), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to new_user_session_path
      end

      it 'but fails to get to the page for providing an id for a restaurant that they dont own' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 24.5, servingable: beverage)
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
        login_as beverage.restaurant.user

        get(edit_restaurant_beverage_serving_path(second_restaurant, beverage, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a beverage that they dont own' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 24.5, servingable: beverage)
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
        second_beverage = Beverage.create!(
          name: 'Coca Cola Zero',
          description: 'Produto sem adição de Açúcar',
          calories: 12,
          is_alcoholic: false,
          restaurant: second_restaurant
        )
        login_as beverage.restaurant.user

        get(edit_restaurant_beverage_serving_path(beverage.restaurant, second_beverage, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'but fails to get to the page for providing an id for a serving that they dont own' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 12.80, servingable: beverage)
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
        second_beverage = Beverage.create!(
          name: 'Coca Cola Zero',
          description: 'Produto sem adição de Açúcar',
          calories: 12,
          is_alcoholic: false,
          restaurant: second_restaurant
        )
        Serving.create!(description: 'Lata 350ml', current_price: 3.80, servingable: second_beverage)
        login_as second_user

        get(edit_restaurant_beverage_serving_path(second_restaurant, second_beverage, serving))

        expect(response.status).to redirect_to root_path
      end

      it 'with success' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 24.5, servingable: beverage)
        login_as beverage.restaurant.user

        patch(
          restaurant_beverage_serving_path(beverage.restaurant, beverage, serving), 
          params: { 
            serving: { 
              description: serving.description,
              current_price: serving.current_price,
            }
          }
        )

        expect(response).to redirect_to restaurant_beverage_path(beverage.restaurant, beverage)
      end

      it 'but fails for providing invalid data' do
        beverage = create_beverage
        serving = Serving.create!(description: 'Garrafa 750ml', current_price: 24.5, servingable: beverage)
        login_as beverage.restaurant.user

        patch(
          restaurant_beverage_serving_path(beverage.restaurant, beverage, serving), 
          params: { 
            serving: { 
              description: '',
              current_price: serving.current_price,
            }
          }
        )

        expect(response.status).to eq 422
      end
    end
  end
end