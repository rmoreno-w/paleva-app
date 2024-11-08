def create_user
  User.create!(
    name: 'Aloisio',
    family_name: 'Silveira',
    registration_number: '08000661110',
    email: 'aloisio@email.com',
    password: 'fortissima12'
  )
end

def new_restaurant
  Restaurant.new(
    brand_name: 'Pizzaria Campus du Codi',
    corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    registration_number: '30.883.175/2481-06',
    address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    phone: '12987654321',
    email: 'campus@ducodi.com.br'
  )
end

def create_restaurant_and_user
  user = create_user
  Restaurant.create!(
    brand_name: 'Pizzaria Campus du Codi',
    corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    registration_number: '30.883.175/2481-06',
    address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    phone: '12987654321',
    email: 'campus@ducodi.com.br',
    user: user
  )
end

def new_dish
  Dish.new(
    name: 'Petit Gateau de Mousse Insuflado',
    description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
    calories: 580,
  )
end

def new_beverage
  Beverage.new(
    name: 'Agua de coco Sócoco',
    description: 'Caixa de 1L. Já vem gelada',
    calories: 150,
    is_alcoholic: false,
  )
end

def create_dish
  restaurant = create_restaurant_and_user

  Dish.create!(
    name: 'Petit Gateau de Mousse Insuflado',
    description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
    calories: 580,
    restaurant: restaurant
  )
end

def create_beverage
  restaurant = create_restaurant_and_user

  Beverage.create!(
    name: 'Agua de coco Sócoco',
    description: 'Caixa de 1L. Já vem gelada',
    calories: 150,
    is_alcoholic: false,
    restaurant: restaurant
  )
end