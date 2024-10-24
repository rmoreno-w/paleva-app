def create_user
  User.create!(
    name: 'Aloisio',
    family_name: 'Silveira',
    registration_number: '08000661110',
    email: 'aloisio@email.com',
    password: 'fortissima12'
  )
end

def create_restaurant
  Restaurant.new(
    brand_name: 'Pizzaria Campus du Codi',
    corporate_name: 'Restaurante Entregas Pizzaria Campus du Codi S.A',
    registration_number: '30.883.175/2481-06',
    address: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP',
    phone: '12987654321',
    email: 'campus@ducodi.com.br'
  )
end