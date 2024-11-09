require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'it should have a customer name' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: '', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_name = order.errors.include? :customer_name

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_name).to eq true
      end

      it 'it should have either a customer email or a customer phone' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '',
          customer_email: '',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_phone = order.errors.include? :customer_phone

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_phone).to eq true
      end

      it 'if it has no customer email, it should have a customer phone' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '12999000099',
          customer_email: '',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_email = order.errors.include? :customer_email

        expect(is_order_valid).to eq true
        expect(has_order_errors_on_customer_email).to eq false
      end

      it 'if it has no customer phone, it should have a customer email' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '',
          customer_email: 'email@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_email = order.errors.include? :customer_email

        expect(is_order_valid).to eq true
        expect(has_order_errors_on_customer_email).to eq false
      end

      it 'it may have no registration number' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '35999000099',
          customer_email: 'email@email.com',
          customer_registration_number: '',
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_registration_number = order.errors.include? :customer_registration_number

        puts order.errors.full_messages.to_a
        expect(is_order_valid).to eq true
        expect(has_order_errors_on_customer_registration_number).to eq false
      end
    end

    context 'validity' do
      it 'should have a valid cpf, if it is present' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@email.com',
          customer_registration_number: '12345678901',
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_registration_number = order.errors.include? :customer_registration_number

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_registration_number).to eq true
      end

      it 'should have a valid email, if it is present' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '35999222299',
          customer_email: 'adeilson@',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_email = order.errors.include? :customer_email

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_email).to eq true
      end

      it 'phone should not have an invalid length (>11 characters)' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '123456789012',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_phone = order.errors.include? :customer_phone

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_phone).to eq true
      end

      it 'phone should not have an invalid length (<10 characters)' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '123456789',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_phone = order.errors.include? :customer_phone

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_phone).to eq true
      end
    end

    context 'numericality' do
      it 'phone should only be composed of integers' do
        restaurant = Restaurant.new()
        order = Order.new(
          customer_name: 'Adeilson', 
          customer_phone: '3599922279.5',
          customer_email: 'adeilson@email.com',
          customer_registration_number: CPF.generate,
          restaurant: restaurant
        )

        is_order_valid = order.valid?
        has_order_errors_on_customer_phone = order.errors.include? :customer_phone

        expect(is_order_valid).to eq false
        expect(has_order_errors_on_customer_phone).to eq true
      end
    end
  end
end
