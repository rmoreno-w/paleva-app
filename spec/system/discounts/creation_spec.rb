require 'rails_helper'

describe 'User tries to create a discount for their restaurant' do
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

    visit new_restaurant_discount_path(restaurant)
    
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
    click_on '+ Criar Desconto'
    
    expect(current_path).to eq new_restaurant_discount_path(restaurant)
    expect(page).to have_content 'Novo Desconto' 
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
    login_as user

    visit root_path
    click_on 'Descontos'
    click_on '+ Criar Desconto'
    fill_in 'Nome', with: 'Semana do Shot'
    fill_in 'Porcentagem de Desconto', with: '30'
    fill_in 'Data de Início', with: 1.day.from_now.to_fs(:db).split(' ').first
    fill_in 'Data de Fim', with: 8.days.from_now.to_fs(:db).split(' ').first
    fill_in 'Limite de Usos (número de Pedidos)', with: '100'
    click_on 'Criar Desconto'

    expect(current_path).to eq restaurant_discounts_path(restaurant)
    expect(page).to have_content 'Desconto criado com sucesso' 
    expect(page).to have_content 'Semana do Shot' 
    expect(page).to have_content '30,00%' 
  end
end