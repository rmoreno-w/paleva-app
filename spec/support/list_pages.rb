def list_pages(restaurant:, beverage:, dish:, dish_serving:, beverage_serving:, tag:, item_set: )
  [
    root_path,

    restaurant_menu_items_search_path(restaurant.id, query: 'a'),

    restaurant_beverage_path(restaurant.id, beverage.id),
    restaurant_beverages_path(restaurant.id),
    new_restaurant_beverage_path(restaurant.id),
    edit_restaurant_beverage_path(restaurant.id, beverage.id),

    restaurant_dish_path(restaurant.id, dish.id),
    restaurant_dishes_path(restaurant.id),
    new_restaurant_dish_path(restaurant.id),
    edit_restaurant_dish_path(restaurant.id, dish.id),

    new_restaurant_restaurant_operating_hour_path(restaurant.id),
    restaurant_restaurant_operating_hours_path(restaurant.id),

    restaurant_dish_serving_history_path(restaurant.id, dish.id, dish_serving.id),
    new_restaurant_dish_serving_path(restaurant.id,dish.id),
    edit_restaurant_dish_serving_path(restaurant.id, dish.id, dish_serving.id),

    restaurant_beverage_serving_history_path(restaurant.id, beverage.id, beverage_serving.id),
    new_restaurant_beverage_serving_path(restaurant.id,beverage.id),
    edit_restaurant_beverage_serving_path(restaurant.id, beverage.id, beverage_serving.id),

    new_restaurant_tag_path(restaurant.id),
    restaurant_dish_new_tag_assignment_path(restaurant.id, dish.id),
    restaurant_exclude_tag_path(restaurant.id),
    restaurant_dish_remove_tag_assignment_path(restaurant.id, dish.id),

    new_restaurant_item_option_set_path(restaurant.id),
    restaurant_item_option_set_path(restaurant.id, item_set.id),
    restaurant_item_option_set_remove_item_path(restaurant.id, item_set.id),
    restaurant_item_option_set_new_beverage_path(restaurant.id, item_set.id),
    restaurant_item_option_set_new_dish_path(restaurant.id, item_set.id),
  ]
end