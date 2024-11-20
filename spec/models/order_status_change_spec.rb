require 'rails_helper'

RSpec.describe OrderStatusChange, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a status' do
        order_status_change = OrderStatusChange.new(status: '')

        is_order_status_change_valid = order_status_change.valid?
        has_order_status_change_errors_on_status = order_status_change.errors.include? :status

        expect(is_order_status_change_valid).to be false
        expect(has_order_status_change_errors_on_status).to be true
      end

      it 'should have a change_time' do
        order_status_change = OrderStatusChange.new(change_time: '')

        is_order_status_change_valid = order_status_change.valid?
        has_order_status_change_errors_on_change_time = order_status_change.errors.include? :change_time

        expect(is_order_status_change_valid).to be false
        expect(has_order_status_change_errors_on_change_time).to be true
      end
    end
  end
end
