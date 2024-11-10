require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        # Arrange
        user = User.new(
          name: '',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        
        is_user_valid = user.valid?
        has_user_errors_on_name = user.errors.include? :name

        expect(is_user_valid).to be false
        expect(has_user_errors_on_name).to be true
      end

      it 'should have a family name' do
        # Arrange
        user = User.new(
          name: 'Aloisio',
          family_name: '',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )
        
        is_user_valid = user.valid?
        has_user_errors_on_family_name = user.errors.include? :family_name

        expect(is_user_valid).to be false
        expect(has_user_errors_on_family_name).to be true
      end

      it 'should have a registration number' do
        # Arrange
        user = User.new(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )

        is_user_valid = user.valid?
        has_user_errors_on_registration_number = user.errors.include? :registration_number

        expect(is_user_valid).to be false
        expect(has_user_errors_on_registration_number).to be true
      end

      it 'should have an email' do
        # Arrange
        user = User.new(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: '',
          password: 'fortissima12'
        )

        is_user_valid = user.valid?
        has_user_errors_on_email = user.errors.include? :email

        expect(is_user_valid).to be false
        expect(has_user_errors_on_email).to be true
      end

      it 'should have a password' do
        # Arrange
        user = User.new(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: ''
        )

        is_user_valid = user.valid?
        has_user_errors_on_password = user.errors.include? :password

        expect(is_user_valid).to be false
        expect(has_user_errors_on_password).to be true
      end
    end

    context '#length' do
      it 'password should be at least 12 characters long' do
        # Arrange
        user = User.new(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'curta'
        )

        is_user_valid = user.valid?
        has_user_errors_on_password = user.errors.include? :password

        expect(is_user_valid).to be false
        expect(has_user_errors_on_password).to be true
      end
    end

    context '#uniqueness' do
      it 'registration number should be unique' do
        # Arrange
        User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )

        user = User.new(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: '08000661110',
          email: 'luan@email.com',
          password: 'fortissima23'
        )

        is_user_valid = user.valid?
        has_user_errors_on_registration_number = user.errors.include? :registration_number

        expect(is_user_valid).to be false
        expect(has_user_errors_on_registration_number).to be true
      end

      it 'email should be unique' do
        # Arrange
        User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )

        user = User.new(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima23'
        )

        is_user_valid = user.valid?
        has_user_errors_on_email = user.errors.include? :email

        expect(is_user_valid).to be false
        expect(has_user_errors_on_email).to be true
      end
    end

    context '#registration number validity' do
      it 'should match the pattern' do
        user = User.new(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: '00000000000',
          email: 'luan@email.com',
          password: 'fortissima12'
        )

        is_user_valid = user.valid?
        has_user_errors_on_registration_number = user.errors.include? :registration_number

        expect(is_user_valid).to be false
        expect(has_user_errors_on_registration_number).to be true
      end
    end

    context '#restaurant ownership' do
      it 'each restaurant must have one and at most one user with role owner tied to it' do
        user = User.create!(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: CPF.generate,
          email: 'luan@email.com',
          password: 'fortissima12',
          role: :owner
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

        second_user = User.new(
          name: 'Rafael',
          family_name: 'de Souza',
          registration_number: CPF.generate,
          email: 'rafael@email.com',
          password: 'fortissima12',
          role: :owner,
          restaurant: restaurant
        )

        is_user_valid = second_user.valid?
        has_user_errors_on_restaurant_id = second_user.errors.include? :restaurant_id

        expect(is_user_valid).to be false
        expect(has_user_errors_on_restaurant_id).to be true
      end
    end
  end
end
