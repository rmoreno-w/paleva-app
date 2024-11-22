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
    dish = Dish.create!(
      name: 'Petit Gateau de Mousse Insuflado',
      description: 'Delicioso bolinho com sorvete. Ao partir, voce é presenteado com massa quentinha escorrendo, parecendo um mousse',
      calories: 580,
      restaurant: restaurant
    )
    serving = dish.servings.create!(description: '1 Bolinho e 1 Bola de Sorvete', current_price: 24.00)
    item_set = ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
    item_set.item_option_entries.create!(itemable: dish)
    discount = Discount.create!(
      name: 'Semana do Petit Gateau',
      percentage: 50,
      start_date: 1.day.ago.to_fs(:db).split(' ').first,
      end_date: 2.weeks.from_now.to_fs(:db).split(' ').first,
      limit_of_uses: 100, 
      restaurant: restaurant
    )
    DiscountedServing.create!(discount: discount, serving: serving)
    login_as user


    # Act
    visit root_path
    click_on 'Almoço'
    find("#serving_#{serving.id}").click
    find("#serving_#{serving.id}").click
    click_on "Pedidos"
    find('#open-order-details').click

    fill_in 'Nome do Cliente', with: 'Aloisio Fonseca'
    fill_in 'E-mail do Cliente', with: 'aloisio_teste@email.com'
    fill_in 'Telefone do Cliente', with: '12999116633'
    fill_in 'CPF do Cliente (Opcional)', with: CPF.generate
    find("#serving_#{serving.id}").set 'Sem Glúten'
    click_on "Realizar Pedido"
    order = Order.last
    visit restaurant_discount_path(restaurant, discount)


    expect(current_path).to eq restaurant_discount_path(restaurant, discount)
    expect(page).to have_content 'Semana do Petit Gateau' 
    expect(page).to have_content 'Porcentagem de Desconto: 50,00%'
    expect(page).to have_content 'Número de descontos já usados: 1'
    expect(page).to have_link "Pedido ##{order.code}"
  end
end