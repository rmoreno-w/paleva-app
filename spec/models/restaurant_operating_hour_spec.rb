require 'rails_helper'

RSpec.describe RestaurantOperatingHour, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a start time' do
        restaurant = create_restaurant_and_user

        operating_hour =  RestaurantOperatingHour.new(
          start_time: '',
          end_time: '10:00',
          status: 0,
          weekday: 0,
          restaurant: restaurant
        )

        is_operating_hour_valid = operating_hour.valid?
        has_operating_hour_error_on_start_time = operating_hour.errors.include? :start_time

        expect(is_operating_hour_valid).to be false
        expect(has_operating_hour_error_on_start_time).to be true
      end

      it 'should have a end time' do
        restaurant = create_restaurant_and_user

        operating_hour =  RestaurantOperatingHour.new(
          start_time: '09:00',
          end_time: '',
          status: 0,
          weekday: 0,
          restaurant: restaurant
        )

        is_operating_hour_valid = operating_hour.valid?
        has_operating_hour_error_on_end_time = operating_hour.errors.include? :end_time

        expect(is_operating_hour_valid).to be false
        expect(has_operating_hour_error_on_end_time).to be true
      end

      it 'should have a status' do
        restaurant = create_restaurant_and_user

        operating_hour =  RestaurantOperatingHour.new(
          start_time: '09:00',
          end_time: '10:00',
          status: nil,
          weekday: 0,
          restaurant: restaurant
        )

        is_operating_hour_valid = operating_hour.valid?
        has_operating_hour_error_on_status = operating_hour.errors.include? :status

        expect(is_operating_hour_valid).to be false
        expect(has_operating_hour_error_on_status).to be true
      end

      it 'should have a weekday' do
        restaurant = create_restaurant_and_user

        operating_hour =  RestaurantOperatingHour.new(
          start_time: '09:00',
          end_time: '10:00',
          status: 0,
          weekday: nil,
          restaurant: restaurant
        )

        is_operating_hour_valid = operating_hour.valid?
        has_operating_hour_error_on_weekday = operating_hour.errors.include? :weekday

        expect(is_operating_hour_valid).to be false
        expect(has_operating_hour_error_on_weekday).to be true
      end
    end

    context 'time period validity' do 
      it 'start_time should be an earlier time when compared to end_time' do
        restaurant = create_restaurant_and_user

        operating_hour =  RestaurantOperatingHour.new(
          start_time: '10:05',
          end_time: '10:00',
          status: 0,
          weekday: 0,
          restaurant: restaurant
        )

        is_operating_hour_valid = operating_hour.valid?
        has_operating_hour_error_on_start_time = operating_hour.errors.include? :start_time

        expect(is_operating_hour_valid).to be false
        expect(has_operating_hour_error_on_start_time).to be true
      end
    end
  end
end
