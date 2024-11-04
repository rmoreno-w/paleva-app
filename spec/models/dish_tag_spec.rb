require 'rails_helper'

RSpec.describe DishTag, type: :model do
  describe '#valid' do
    context 'uniqueness' do
      it 'should repeat a tag for a dish' do
        dish = create_dish
        tag = Tag.create(name: 'Vegano', restaurant: dish.restaurant)

        dish.tags << tag
        dish_tag = DishTag.new(tag_id: tag.id, dish_id: dish.id)
        dish_tag.valid?

        number_of_tags_assigned_to_dish = dish.tags.count
        has_dish_tag_error_on_dish_id = dish_tag.errors.include? :dish_id

        expect(number_of_tags_assigned_to_dish).to eq 1
        expect(has_dish_tag_error_on_dish_id).to eq true
      end
    end
  end
end
