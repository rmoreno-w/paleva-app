require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a brand name' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: '',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_brand_name = restaurant.errors.include? :brand_name

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_brand_name).to be true
      end

      it 'should have a corporate name' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: '',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_corporate_name = restaurant.errors.include? :corporate_name

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_corporate_name).to be true
      end

      it 'should have a registration number' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_registration_number = restaurant.errors.include? :registration_number

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_registration_number).to be true
      end

      it 'should have an address' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: '',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_address = restaurant.errors.include? :address

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_address).to be true
      end

      it 'should have a phone' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_phone = restaurant.errors.include? :phone

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_phone).to be true
      end

      it 'should have an email' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: '',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_email = restaurant.errors.include? :email

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_email).to be true
      end

      it 'should have a code' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '12987654321',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_code = restaurant.errors.include? :code

        expect(is_restaurant_valid).to be true
        expect(has_restaurant_errors_on_code).to be false
        expect(restaurant.code.length).to eq 6
      end
    end

    context 'length' do
      it 'phone should not have less than 10 characters' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '123456789',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_phone = restaurant.errors.include? :phone

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_phone).to be true
      end

      it 'phone should not have less than 10 characters' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '123456789012',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_phone = restaurant.errors.include? :phone

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_phone).to be true
      end
    end

    context 'numericality' do
      it 'phone should be composed by only numerical characters' do
        u = create_user
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: 'aaaaaaaaaa',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_phone = restaurant.errors.include? :phone
        has_restaurant_numericality_errors = restaurant.errors[:phone].include? 'não é um número'

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_phone).to be true
        expect(has_restaurant_numericality_errors).to be true
      end
    end

    context 'uniqueness' do
      it 'user can only have one restaurant linked to his profile' do
        # Arrange
        u = User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        Restaurant.create!(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '11.957.634/0977-26',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '9876543210',
          email: 'campus@ducodi.com.br',
          user: u
        )
        second_restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Contra',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Contra S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Cocais, 42. Bairro Laranjeiras. CEP: 50.001-002. Cubatão - SP',
          phone: '98765123401',
          email: 'campus@ducontra.com.br',
          user: u
        )

        is_second_restaurant_valid = second_restaurant.valid?
        has_second_restaurant_errors_on_user = second_restaurant.errors.include? :user_id

        expect(is_second_restaurant_valid).to be false
        expect(has_second_restaurant_errors_on_user).to be true
      end

      it 'code should be unique' do
        first_user = User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: CPF.generate,
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        second_user = User.create!(
          name: 'Alonso',
          family_name: 'de la Vega',
          registration_number: CPF.generate,
          email: 'alonso@email.com',
          password: 'fortissima12'
        )
        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')

        Restaurant.create!(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '11.957.634/0977-26',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '9876543210',
          email: 'campus@ducodi.com.br',
          user: first_user
        )

        allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Contra',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Contra S.A',
          registration_number: '62.354.981/5223-31',
          address: 'Rua Barão de Cocais, 42. Bairro Laranjeiras. CEP: 50.001-002. Cubatão - SP',
          phone: '98765123401',
          email: 'campus@ducontra.com.br',
          user: second_user
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_code = restaurant.errors.include? :code

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_code).to be true
      end
    end

    context 'registration number validity' do
      it 'should match the pattern' do
        u = User.create!(
            name: 'Aloisio',
            family_name: 'Silveira',
            registration_number: '08000661110',
            email: 'aloisio@email.com',
            password: 'fortissima12'
            )
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '0856.98774.931125/00005-82',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '9876543210',
          email: 'campus@ducodi.com.br',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_registration_number = restaurant.errors.include? :registration_number

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_registration_number).to be true
      end
    end

    context 'email validity' do
      it 'should match the pattern' do
        u = User.create!(
            name: 'Aloisio',
            family_name: 'Silveira',
            registration_number: '08000661110',
            email: 'aloisio@email.com',
            password: 'fortissima12'
            )
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '11.957.634/0977-26',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '9876543210',
          email: 'a@a',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        has_restaurant_errors_on_email = restaurant.errors.include? :email

        expect(is_restaurant_valid).to be false
        expect(has_restaurant_errors_on_email).to be true
      end
    end
  end

  describe '#code generation' do
    it "should happen automatically before a restaurant is registered" do
      u = User.create!(
            name: 'Aloisio',
            family_name: 'Silveira',
            registration_number: '08000661110',
            email: 'aloisio@email.com',
            password: 'fortissima12'
            )
        restaurant = Restaurant.new(
          brand_name: 'Pizzaria Campus du Codi',
          corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
          registration_number: '11.957.634/0977-26',
          address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
          phone: '9876543210',
          email: 'campus@ducodi.com',
          user: u
        )

        is_restaurant_valid = restaurant.valid?
        code = restaurant.code

        expect(is_restaurant_valid).to be true
        expect(code).not_to be ''
        expect(code.length).to eq 6
    end
  end

  describe '#user attribution' do
    it "should add the restaurant id to the user when registering them as an owner" do
      u = User.create!(
        name: 'Aloisio',
        family_name: 'Silveira',
        registration_number: '08000661110',
        email: 'aloisio@email.com',
        password: 'fortissima12'
      )
      restaurant = Restaurant.create!(
        brand_name: 'Pizzaria Campus du Codi',
        corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
        registration_number: '11.957.634/0977-26',
        address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
        phone: '9876543210',
        email: 'campus@ducodi.com',
        user: u
      )

      has_user_a_restaurant = u.restaurant.present?
      is_user_restaurant_the_newly_created_restaurant = u.restaurant == restaurant

      expect(has_user_a_restaurant).to be true
      expect(is_user_restaurant_the_newly_created_restaurant).to be true
    end
  end
end
