require 'rails_helper'

describe 'User' do
  context 'tries to create a tag' do
    it 'but cannot access the creation page if they are not authenticated' do
      restaurant = create_restaurant_and_user
      tag = Tag.new(name: 'Vegano')

      get(new_restaurant_tag_path(restaurant))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot create a tag (post it) if they are not authenticated' do
      restaurant = create_restaurant_and_user

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
      restaurant = create_restaurant_and_user
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
      restaurant = create_restaurant_and_user
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
      restaurant = create_restaurant_and_user

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
      restaurant = create_restaurant_and_user

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
      restaurant = create_restaurant_and_user
      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)

      get(restaurant_exclude_tag_path(restaurant))

      expect(response).to redirect_to new_user_session_path
    end

    it 'but cannot delete a tag if they are not authenticated' do
      restaurant = create_restaurant_and_user
      tag = Tag.create!(name: 'Vegano', restaurant: restaurant)

      delete(restaurant_destroy_tag_path(restaurant),
        params: {
          tag_id: tag.id
        }
      )

      expect(response).to redirect_to new_user_session_path
    end

    it 'but fails to get to the form to delete a tag for providing an id for a restaurant that they dont own' do
      restaurant = create_restaurant_and_user
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
      restaurant = create_restaurant_and_user
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
      restaurant = create_restaurant_and_user
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
end