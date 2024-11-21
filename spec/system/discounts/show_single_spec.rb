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
    discount = Discount.create!(
      name: 'Semana da Batata Frita',
      percentage: 30,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )

    visit restaurant_discount_path(restaurant, discount)
    
    expect(current_path).to eq new_user_session_path
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
    discount = Discount.create!(
      name: 'Semana da Batata Frita',
      percentage: 30,
      start_date: 1.week.from_now.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    login_as user

    visit root_path
    click_on 'Descontos'
    click_on 'Semana da Batata Frita'

    expect(current_path).to eq restaurant_discount_path(restaurant, discount)
    expect(page).to have_content 'Semana da Batata Frita' 
    expect(page).to have_content 'Porcentagem de Desconto: 30,00%'
    expect(page).to have_content "Data de Início: #{I18n.l(discount.start_date)}"
    expect(page).to have_content "Data de Fim: #{I18n.l(discount.end_date)}"
    expect(page).to have_content "Limite de Usos (número de Pedidos): 100"
  end
end