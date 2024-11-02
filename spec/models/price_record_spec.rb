require 'rails_helper'

RSpec.describe PriceRecord, type: :model do
  describe '#valid' do
    context 'presence' do
        it 'should have a change date' do
          serving = Serving.new
          price_record = PriceRecord.new(change_date: nil, price: 25.5, serving: serving)

          is_price_record_valid = price_record.valid?
          has_price_record_errors_on_change_date = price_record.errors.include? :change_date

          expect(is_price_record_valid).to be false
          expect(has_price_record_errors_on_change_date).to be true
        end

        it 'should have a price' do
          serving = Serving.new
          price_record = PriceRecord.new(change_date: 1.second.from_now, price: nil, serving: serving)

          is_price_record_valid = price_record.valid?
          has_price_record_errors_on_price = price_record.errors.include? :price

          expect(is_price_record_valid).to be false
          expect(has_price_record_errors_on_price).to be true
        end
      end
  end

  describe '#numericality' do
    it 'price should be greater than 0' do
      serving = Serving.new
      price_record = PriceRecord.new(change_date: 1.second.from_now, price: -25.5, serving: serving)

      is_price_record_valid = price_record.valid?
      has_price_record_errors_on_price = price_record.errors.include? :price

      expect(is_price_record_valid).to be false
      expect(has_price_record_errors_on_price).to be true
    end
  end

  describe '#valid_date' do
    it 'change_date should not be in the past' do
      serving = Serving.new
      price_record = PriceRecord.new(change_date: 1.second.ago, price: 25.5, serving: serving)

      is_price_record_valid = price_record.valid?
      has_price_record_errors_on_change_date = price_record.errors.include? :change_date

      expect(is_price_record_valid).to be false
      expect(has_price_record_errors_on_change_date).to be true
    end
  end
end
