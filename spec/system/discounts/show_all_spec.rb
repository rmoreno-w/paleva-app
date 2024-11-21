require 'rails_helper'

describe 'User tries to visualize the discounts for their restaurant' do
  it 'but first has to be logged in' do
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

    visit restaurant_discounts_path(restaurant)
    
    expect(current_path).to eq new_user_session_path
  end

  it 'and gets to the correct page' do
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
    login_as user

    visit root_path
    click_on 'Descontos'
    
    expect(current_path).to eq restaurant_discounts_path(restaurant)
    within 'main' do
      expect(page).to have_content 'Descontos' 
    end
  end

  it 'and succeeds' do
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
    Discount.create!(
      name: 'Semana da Batata Frita',
      percentage: 30,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    Discount.create!(
      name: 'Semana do Suco de Laranja',
      percentage: 15,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    login_as user

    visit root_path
    click_on 'Descontos'

    expect(current_path).to eq restaurant_discounts_path(restaurant)
    expect(page).to have_content 'Semana da Batata Frita' 
    expect(page).to have_content '30,00%' 
    expect(page).to have_content 'Semana do Suco de Laranja' 
    expect(page).to have_content '15,00%' 
  end

  it 'and should not see discounts from other restaurants' do
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
    Discount.create!(
      name: 'Semana da Batata Frita',
      percentage: 30,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    Discount.create!(
      name: 'Semana do Suco de Laranja',
      percentage: 15,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    login_as user
    second_user = User.create!(
      name: 'Jacquin',
      family_name: 'DuFrance',
      registration_number: CPF.generate,
      email: 'ajc@cquin.com',
      password: 'fortissima12'
    )
    second_restaurant = Restaurant.create!(
      brand_name: 'Boulangerie JQ',
      corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
      registration_number: CNPJ.generate,
      address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
      phone: '12988774532',
      email: 'atendimento@bjq.com.br',
      user: second_user
    )
    Discount.create!(
      name: 'Semana da Comida Francesa',
      percentage: 7,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 20, 
      restaurant: second_restaurant
    )

    visit root_path
    click_on 'Descontos'

    expect(current_path).to eq restaurant_discounts_path(restaurant)
    expect(page).to have_content 'Semana da Batata Frita' 
    expect(page).to have_content '30,00%' 
    expect(page).to have_content 'Semana do Suco de Laranja' 
    expect(page).to have_content '15,00%' 
    expect(page).not_to have_content 'Semana da Comida Francesa' 
    expect(page).not_to have_content '7,00%' 
  end
end