require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        restaurant = create_restaurant_and_user

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
        restaurant = create_restaurant_and_user

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
