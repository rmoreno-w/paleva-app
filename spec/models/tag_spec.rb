require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        tag = Tag.new(name: '')

        is_tag_valid = tag.valid?
        has_tag_errors_on_name = tag.errors.include? :name

        expect(is_tag_valid).to be false
        expect(has_tag_errors_on_name).to be true
      end
    end

    context 'uniqueness' do
      it 'should have a unique name' do
        restaurant = create_restaurant_and_user
        Tag.create!(name: 'Vegana', restaurant: restaurant)
        tag = Tag.new(name: 'Vegana')

        is_tag_valid = tag.valid?
        has_tag_errors_on_name = tag.errors.include? :name

        expect(is_tag_valid).to be false
        expect(has_tag_errors_on_name).to be true
      end
    end
  end
end
