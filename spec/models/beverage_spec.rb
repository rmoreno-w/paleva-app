require 'rails_helper'

RSpec.describe Beverage, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        restaurant = create_restaurant_and_user

        beverage =  Beverage.new(
          name: '',
          description: 'Caixa de 1L. Já vem gelada',
          calories: 150,
          is_alcoholic: false,
          restaurant: restaurant
        )
        beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')

        is_beverage_valid = beverage.valid?
        has_beverage_error_on_name = beverage.errors.include? :name

        expect(is_beverage_valid).to be false
        expect(has_beverage_error_on_name).to be true
      end

      it 'should have a description' do
        restaurant = create_restaurant_and_user

        beverage =  Beverage.new(
          name: 'Água de Coco',
          description: '',
          calories: 150,
          is_alcoholic: false,
          restaurant: restaurant
        )
        beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')

        is_beverage_valid = beverage.valid?
        has_beverage_errors_on_description = beverage.errors.include? :description

        expect(is_beverage_valid).to be false
        expect(has_beverage_errors_on_description).to be true
      end

      it 'should have calories' do
        restaurant = create_restaurant_and_user

        beverage =  Beverage.new(
          name: 'Água de Coco',
          description: 'Caixa de 1L. Já vem gelada',
          calories: nil,
          is_alcoholic: false,
          restaurant: restaurant
        )
        beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')

        is_beverage_valid = beverage.valid?
        has_beverage_errors_on_calories = beverage.errors.include? :calories

        expect(is_beverage_valid).to be false
        expect(has_beverage_errors_on_calories).to be true
      end

      it 'should have alcoholic field' do
        restaurant = create_restaurant_and_user

        beverage =  Beverage.new(
          name: 'Água de Coco',
          description: 'Caixa de 1L. Já vem gelada',
          calories: 150,
          is_alcoholic: nil,
          restaurant: restaurant
        )
        beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')

        is_beverage_valid = beverage.valid?
        has_beverage_errors_on_alcoholic_field = beverage.errors.include? :is_alcoholic

        expect(is_beverage_valid).to be false
        expect(has_beverage_errors_on_alcoholic_field).to be true
      end
    end

    context '#default value' do
      it 'is_alcoholic should have a default value of false' do
        restaurant = create_restaurant_and_user

        beverage =  Beverage.new(
          name: 'Água de Coco',
          description: 'Caixa de 1L. Já vem gelada',
          calories: 150,
          restaurant: restaurant
        )
        beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')

        is_beverage_valid = beverage.valid?
        has_beverage_error_on_is_alcoholic = beverage.errors.include? :name

        expect(is_beverage_valid).to be true
        expect(has_beverage_error_on_is_alcoholic).to be false
        expect(beverage.is_alcoholic).to be false
      end
    end
  end
end
