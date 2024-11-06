class ItemOptionEntry < ApplicationRecord
  belongs_to :itemable, polymorphic: true
  belongs_to :item_option_set

  def item_name
    self.itemable.name
  end
end
