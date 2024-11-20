require 'rails_helper'

RSpec.describe OrderStatusChangeAnnotation, type: :model do
  it 'should have an annotation' do
    order_status_change_annotation = OrderStatusChangeAnnotation.new(annotation: '')

    is_order_status_change_annotation_valid = order_status_change_annotation.valid?
    has_order_status_change_annotation_errors_on_status = order_status_change_annotation.errors.include? :annotation

    expect(is_order_status_change_annotation_valid).to be false
    expect(has_order_status_change_annotation_errors_on_status).to be true
  end
end
