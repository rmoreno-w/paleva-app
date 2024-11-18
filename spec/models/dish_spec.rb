require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
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

        dish =  Dish.new(
          name: '',
          description: 'Chocolate Nestlé 180g',
          calories: 350,
          restaurant: restaurant
        )
        dish.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'browniee.jpg')), filename: 'browniee.jpg')


        is_dish_valid = dish.valid?
        has_dish_error_on_name = dish.errors.include? :name


        expect(is_dish_valid).to be false
        expect(has_dish_error_on_name).to be true
      end

      it 'should have a description' do
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

        dish =  Dish.new(
          name: 'Sufflair',
          description: '',
          calories: 350,
          restaurant: restaurant
        )
        dish.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'browniee.jpg')), filename: 'browniee.jpg')


        is_dish_valid = dish.valid?
        description = dish.errors.include? :description


        expect(is_dish_valid).to be false
        expect(description).to be true
      end
    end
  end
end
