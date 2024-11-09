require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have an item name' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: '', 
          serving_description: 'Caixa de 1L',
          serving_price: 13.9,
          number_of_servings: 1,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_item_name = order_item.errors.include? :item_name

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_item_name).to eq true
      end

      it 'should have a serving description' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: 'Água de Coco', 
          serving_description: '',
          serving_price: 13.9,
          number_of_servings: 1,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_serving_description = order_item.errors.include? :serving_description

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_serving_description).to eq true
      end

      it 'should have an serving_price' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: 'Água de Coco', 
          serving_description: 'Caixa de 1L',
          serving_price: nil,
          number_of_servings: 1,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_serving_price = order_item.errors.include? :serving_price

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_serving_price).to eq true
      end

      it 'should have a number of servings' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: 'Água de Coco', 
          serving_description: 'Caixa de 1L',
          serving_price: 13.9,
          number_of_servings: nil,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_number_of_servings = order_item.errors.include? :number_of_servings

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_number_of_servings).to eq true
      end
    end

    context 'numericality' do
      it 'serving price should be a positive number' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: '', 
          serving_description: 'Caixa de 1L',
          serving_price: -13.9,
          number_of_servings: 1,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_serving_price = order_item.errors.include? :serving_price

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_serving_price).to eq true
      end

      it 'number of servings should be a positive number' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: '', 
          serving_description: 'Caixa de 1L',
          serving_price: 13.9,
          number_of_servings: -1,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_number_of_servings = order_item.errors.include? :number_of_servings

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_number_of_servings).to eq true
      end

      it 'number of servings should be an integer' do
        order = Order.new()
        order_item = OrderItem.new(
          item_name: '', 
          serving_description: 'Caixa de 1L',
          serving_price: 13.9,
          number_of_servings: 0.5,
          order: order
        )

        is_order_item_valid = order_item.valid?
        has_order_item_errors_on_number_of_servings = order_item.errors.include? :number_of_servings

        expect(is_order_item_valid).to eq false
        expect(has_order_item_errors_on_number_of_servings).to eq true
      end
    end
  end
end
