class DishTag < ApplicationRecord
  belongs_to :dish
  belongs_to :tag

  validate :verify_uniqueness

  private
  def verify_uniqueness
    tag_id = self.tag_id
    dish_id = self.dish_id

    self.errors.add(:dish_id, 'tag não pode ser repetida') if DishTag.find_by(dish_id: dish_id, tag_id: tag_id)
  end
end
