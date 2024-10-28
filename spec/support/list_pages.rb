def list_pages(restaurant:, beverage:, dish: )
  routes = [
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
  ]
end