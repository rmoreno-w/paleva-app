# Usuário Dono de Restaurante
user = User.create!(
  name: 'Aloisio',
  family_name: 'Silveira',
  registration_number: '08000661110',
  email: 'aloisio@email.com',
  password: 'fortissima12'
)
restaurant = Restaurant.create!(
  brand_name: 'Pizzaria Campus du Codi',
  corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
  registration_number: '30.883.175/2481-06',
  address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
  phone: '12987654321',
  email: 'campus@ducodi.com.br',
  user: user
)
restaurant.restaurant_operating_hours.create!(start_time: '09:00', end_time: '12:00', status: 1, weekday: 1)
restaurant.restaurant_operating_hours.create!(start_time: '13:00', end_time: '18:00', status: 1, weekday: 1)
# Usuário Funcionário
pre_registration = PreRegistration.create!(registration_number: CPF.generate, email: 'anderson@email.com', status: :registered, restaurant: restaurant)
User.create!(
  name: 'Anderson',
  family_name: 'Magalhães',
  registration_number: pre_registration.registration_number,
  email: 'anderson@email.com',
  password: 'fortissima12',
  restaurant: restaurant,
  role: :staff
)


beverage = Beverage.create!(
  name: 'Água de Coco Sócoco',
  description: 'Já vem gelada',
  calories: 150,
  is_alcoholic: false,
  restaurant: restaurant
)
beverage.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'agua_coco.jpeg')
beverage.servings.create!(description: 'Caixa de 1L', current_price: 12.5)
beverage.servings.create!(description: 'Garrafa 750ml', current_price: 8.5)


dish = Dish.create!(
  name: 'Brownie du Codi',
  description: 'Delicioso bolinho com massa fofinha e cobertura de frutas',
  calories: 580,
  restaurant: restaurant
)
dish.picture.attach(io: File.open(Rails.root.join('spec', 'support', 'agua_coco.jpeg')), filename: 'browniee.jpg')
dish.servings.create!(description: 'Pedaço pequeno - 10x10cm', current_price: 9.5)
dish.servings.create!(description: 'Pedaço grande - 20x20cm', current_price: 16.5)
tag = Tag.create!(name: 'Sobremesas', restaurant: restaurant)
DishTag.create!(dish: dish, tag: tag)

item_set = ItemOptionSet.create!(name: 'Café da Tarde', restaurant: restaurant)
item_set.item_option_entries.create!(itemable: dish)
item_set.item_option_entries.create!(itemable: beverage)

