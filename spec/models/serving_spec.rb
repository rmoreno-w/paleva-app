require 'rails_helper'

RSpec.describe Serving, type: :model do
  describe '#valid' do
    context 'presence' do
      context 'when creating for a Dish' do
        it 'should have a description' do
          dish = create_dish
          serving = Serving.new(description: '', current_price: 25.5, servingable: dish)

          is_serving_valid = serving.valid?
          has_serving_errors_on_description = serving.errors.include? :description

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_description).to be true
        end

        it 'should have a current price' do
          dish = create_dish
          serving = Serving.new(description: 'Bolinho individual', current_price: nil, servingable: dish)

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end
      end

      context 'when creating for a Beverage' do
        it 'should have a description' do
          beverage = create_beverage
          serving = Serving.new(description: '', current_price: 25.5, servingable: beverage)

          is_serving_valid = serving.valid?
          has_serving_errors_on_description = serving.errors.include? :description

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_description).to be true
        end

        it 'should have a current price' do
          beverage = create_beverage
          serving = Serving.new(description: 'Garrafa de 750ml', current_price: nil, servingable: beverage)

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end
      end

      it 'should be linked to a Dish or a Beverge' do
        serving = Serving.new(description: 'Bolinho individual', current_price: 25.5, servingable: nil)

        is_serving_valid = serving.valid?
        has_serving_errors_on_servingable = serving.errors.include? :servingable

        expect(is_serving_valid).to be false
        expect(has_serving_errors_on_servingable).to be true
      end
    end
  end

  describe '#numericality' do
    context 'current price' do
      context 'for a Dish' do
        it 'should be greater than 0 when creating a Serving' do
          dish = create_dish
          serving = Serving.new(description: '1 Bolinho', current_price: -25.5, servingable: dish)

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end

        it 'should be greater than 0 when updating a Serving' do
          dish = create_dish
          serving = Serving.create!(description: '1 Bolinho', current_price: 5.5, servingable: dish)
          serving.current_price = -35.6

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end
      end

      context 'for a Beverage' do
        it 'should be greater than 0 when creating a Serving' do
          beverage = create_beverage
          serving = Serving.new(description: 'Garrafa 750ml', current_price: -25.5, servingable: beverage)

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end

        it 'should be greater than 0 when updating a Serving' do
          beverage = create_beverage
          serving = Serving.create!(description: 'Garrafa 750ml', current_price: 5.5, servingable: beverage)
          serving.current_price = -35.6

          is_serving_valid = serving.valid?
          has_serving_errors_on_current_price = serving.errors.include? :current_price

          expect(is_serving_valid).to be false
          expect(has_serving_errors_on_current_price).to be true
        end
      end
    end
  end

  context '#price registry generation' do
    it 'should generate an initial price registry when creating a serving for a Dish' do
      dish = create_dish
      serving = Serving.create!(description: '1 bolinho', current_price: 25.5, servingable: dish)

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      is_price_history_empty = serving.price_history.empty?
      first_price_on_price_history = serving.price_history[0].price

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(is_price_history_empty).to be false
      expect(first_price_on_price_history).to eq 25.5
    end

    it 'should generate an initial price registry when creating a serving for a Beverage' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa 750ml', current_price: 25.5, servingable: beverage)

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      is_price_history_empty = serving.price_history.empty?
      first_price_on_price_history = serving.price_history[0].price

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(is_price_history_empty).to be false
      expect(first_price_on_price_history).to eq 25.5
    end

    it 'should generate a price registry automatically when updating the price of a serving for a Dish' do
      dish = create_dish
      serving = Serving.create!(description: '1 bolinho', current_price: 25.5, servingable: dish)
      serving.current_price = 30.90
      serving.save

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      does_price_history_have_two_registers = serving.price_history.length == 2

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(does_price_history_have_two_registers).to be true
    end

    it 'should generate a price registry automatically when updating the price of a serving for a Beverage' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      serving.current_price = 14.90
      serving.save

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      does_price_history_have_two_registers = serving.price_history.length == 2

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(does_price_history_have_two_registers).to be true
    end

    it 'should not generate a price registry automatically when updating the description of a serving for a Dish' do
      dish = create_dish
      serving = Serving.create!(description: '1 bolinho', current_price: 25.5, servingable: dish)
      serving.description = '2 bolinhos, servem 2 pessoas'
      serving.save

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      does_price_history_have_two_registers = serving.price_history.length == 2

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(does_price_history_have_two_registers).to be false
    end

    it 'should not generate a price registry automatically when updating the description of a serving for a Beverage' do
      beverage = create_beverage
      serving = Serving.create!(description: 'Garrafa 750ml', current_price: 12.5, servingable: beverage)
      serving.description = 'Garrafa 1L'
      serving.save

      is_serving_valid = serving.valid?
      number_of_serving_errors = serving.errors.count
      does_price_history_have_two_registers = serving.price_history.length == 2

      expect(is_serving_valid).to be true
      expect(number_of_serving_errors).to eq 0
      expect(does_price_history_have_two_registers).to be false
    end
  end
end
