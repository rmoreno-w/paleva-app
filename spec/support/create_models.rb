def create_user
  User.create!(
    name: 'Aloisio',
    family_name: 'Silveira',
    registration_number: '08000661110',
    email: 'aloisio@email.com',
    password: 'fortissima12'
  )
end