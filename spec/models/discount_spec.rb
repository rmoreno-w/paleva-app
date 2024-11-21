require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        discount = Discount.new(
          name: '',
          percentage: 30,
          start_date: 1.week.from_now,
          end_date: 2.weeks.from_now,
          limit_of_uses: 30
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_name = discount.errors.include? :name

        expect(is_discount_valid).to be false
        expect(has_discount_errors_on_name).to be true
      end

      it 'should have a percentage' do
        discount = Discount.new(
          name: 'Semana do Suco de Laranja',
          percentage: nil,
          start_date: 1.week.from_now,
          end_date: 2.weeks.from_now,
          limit_of_uses: 30
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_percentage = discount.errors.include? :percentage

        expect(is_discount_valid).to be false
        expect(has_discount_errors_on_percentage).to be true
      end

      it 'should have a start_date' do
        discount = Discount.new(
          name: 'Semana do Suco de Laranja',
          percentage: 30,
          start_date: nil,
          end_date: 2.weeks.from_now,
          limit_of_uses: 30
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_start_date = discount.errors.include? :start_date

        expect(is_discount_valid).to be false
        expect(has_discount_errors_on_start_date).to be true
      end

      it 'should have a end_date' do
        discount = Discount.new(
          name: 'Semana do Suco de Laranja',
          percentage: 30,
          start_date: 1.week.from_now,
          end_date: nil,
          limit_of_uses: 30
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_end_date = discount.errors.include? :end_date

        expect(is_discount_valid).to be false
        expect(has_discount_errors_on_end_date).to be true
      end

      it 'may have no limit_of_uses' do
        restaurant = Restaurant.new()
        discount = Discount.new(
          name: 'Semana do Suco de Laranja',
          percentage: 30,
          start_date: 1.week.from_now,
          end_date: 2.weeks.from_now,
          restaurant: restaurant,
          limit_of_uses: nil
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_limit_of_uses = discount.errors.include? :limit_of_uses

        expect(is_discount_valid).to be true
        expect(has_discount_errors_on_limit_of_uses).to be false
      end
    end

    context 'comparison' do
      it 'end date should be a date post start date' do
        discount = Discount.new(
          name: 'Semana do Suco de Laranja',
          percentage: 30,
          start_date: 2.week.from_now,
          end_date: 1.weeks.from_now,
          limit_of_uses: 30
        )

        is_discount_valid = discount.valid?
        has_discount_errors_on_end_date = discount.errors.include? :end_date

        expect(is_discount_valid).to be false
        expect(has_discount_errors_on_end_date).to be true
      end
    end
  end
end
