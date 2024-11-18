require 'rails_helper'

describe 'User' do
  context 'tries to create a tag' do
    it 'but cannot access the creation page if they are not authenticated' do
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
      Tag.new(name: 'Vegano')

      get(new_restaurant_tag_path(restaurant))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot create a tag (post it) if they are not authenticated' do
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

      post(restaurant_tags_path(restaurant),
        params: {
          tag: {
            name: 'Vegano'
          }
        }
      )

      expect(response).to redirect_to new_user_session_path
    end

    it 'but fails to get to the creation page for providing an id for a restaurant that they dont own' do
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

      login_as restaurant.user

      get(new_restaurant_tag_path(second_restaurant))

      expect(response.status).to redirect_to root_path
    end

    it 'but fails to create a tag providing an id for a restaurant that they dont own' do
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

      login_as restaurant.user


      post(restaurant_tags_path(second_restaurant),
        params: {
          tag: {
            name: 'Vegano'
          }
        }
      )


      expect(response.status).to redirect_to root_path
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

      post(restaurant_tags_path(restaurant),
        params: {
          tag: {
            name: 'Vegano'
          }
        }
      )

      expect(response.status).to redirect_to restaurant_dishes_path
    end

    it 'but fails for providing invalid data - empty name' do
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


      post(restaurant_tags_path(restaurant),
        params: {
          tag: {
            name: ''
          }
        }
      )


      expect(response.status).to eq 422
    end
  end

  context 'tries to delete a tag' do
    it 'but cannot get access to the form if they are not authenticated' do
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
      Tag.create!(name: 'Vegano', restaurant: restaurant)

      get(restaurant_exclude_tag_path(restaurant))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot delete a tag if they are not authenticated' do
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
      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)

      delete(restaurant_destroy_tag_path(restaurant),
        params: {
          tag_id: tag.id
        }
      )

      expect(response).to redirect_to new_user_session_path
    end

    it 'but fails to get to the form to delete a tag for providing an id for a restaurant that they dont own' do
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
      tag = Tag.new(name: 'Vegano', restaurant: restaurant)
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

      login_as restaurant.user


      delete(restaurant_destroy_tag_path(second_restaurant),
        params: {
          tag_id: tag.id
        }
      )


      expect(response.status).to redirect_to root_path
    end

    it 'but fails to delete a tag providing an id for a restaurant that they dont own' do
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
      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)
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

      login_as restaurant.user


      delete(restaurant_destroy_tag_path(second_restaurant),
        params: {
          tag_id: tag.id
        }
      )


      expect(response.status).to redirect_to root_path
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
      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)

      login_as restaurant.user


      delete(restaurant_destroy_tag_path(restaurant),
        params: {
          tag_id: tag.id
        }
      )


      expect(response.status).to redirect_to restaurant_dishes_path
    end
  end

  context 'tries to assign a tag to a dish' do
    it 'but cannot get access to the form if they are not authenticated' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      get(restaurant_dish_new_tag_assignment_path(dish.restaurant, dish))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot assign if they are not authenticated' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      post(restaurant_dish_assign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response).to redirect_to new_user_session_path
    end

    it 'but fails to get to the form to assign a tag for providing an id for a restaurant that they dont own' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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

      get(restaurant_dish_new_tag_assignment_path(second_restaurant, dish))

      expect(response.status).to redirect_to root_path
    end

    it 'but fails to delete a tag providing an id for a restaurant that they dont own' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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

      post(restaurant_dish_assign_tag_path(second_restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing a dish that is not from the restaurant the user owns' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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
        name: 'Bolo de Sufflair',
        description: 'Usando Farinha Láctea Nestle',
        calories: 258,
        restaurant: second_restaurant
      )
      tag = Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)

      login_as dish.restaurant.user

      post(restaurant_dish_assign_tag_path(dish.restaurant, second_dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing a tag that is not from the restaurant the user owns' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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
      tag = Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)

      login_as dish.restaurant.user

      post(restaurant_dish_assign_tag_path(second_restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing invalid data - empty id' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      post(restaurant_dish_assign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: ''
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing invalid data - empty id' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      post(restaurant_dish_assign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id + 1
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and succeeds' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      post(restaurant_dish_assign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
    end
  end

  context 'tries to unassign a tag to a dish' do
    it 'but cannot get access to the form if they are not authenticated' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      get(restaurant_dish_remove_tag_assignment_path(dish.restaurant, dish))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot unassign if they are not authenticated' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response).to redirect_to new_user_session_path
    end

    it 'but fails to get to the form to assign a tag for providing an id for a restaurant that they dont own' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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

      get(restaurant_dish_remove_tag_assignment_path(second_restaurant, dish))

      expect(response.status).to redirect_to root_path
    end

    it 'but fails to delete a tag providing an id for a restaurant that they dont own' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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

      delete(restaurant_dish_unassign_tag_path(second_restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing a dish that is not from the restaurant the user owns' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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
        name: 'Bolo de Sufflair',
        description: 'Usando Farinha Láctea Nestle',
        calories: 258,
        restaurant: second_restaurant
      )
      tag = Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, second_dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing a tag that is not from the restaurant the user owns' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
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
      tag = Tag.create!(name: 'Sobremesa', restaurant: second_restaurant)

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(second_restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing invalid data - empty id' do
      dish = create_dish
      Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: ''
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing invalid data - empty id' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id + 1
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and fails for providing invalid data - tag id not associated to the dish' do
      dish = create_dish
      dish.tags << Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      tag = Tag.create!(name: 'Sobremesa', restaurant: dish.restaurant)

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to root_path
    end

    it 'and succeeds' do
      dish = create_dish
      tag = Tag.create!(name: 'Vegano', restaurant: dish.restaurant)
      dish.tags << tag

      login_as dish.restaurant.user

      delete(restaurant_dish_unassign_tag_path(dish.restaurant, dish),
        params: {
          tag_id: tag.id
        }
      )

      expect(response.status).to redirect_to restaurant_dish_path(dish.restaurant, dish)
    end
  end
end