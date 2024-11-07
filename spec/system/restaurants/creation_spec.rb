require 'rails_helper'

describe 'User' do
  it 'needs to be logged in to see the initial page' do
    visit new_restaurant_path

    expect(page).not_to have_content 'Criar meu restaurante'
    expect(current_path).not_to eq new_restaurant_path
    expect(current_path).to eq new_user_session_path
  end

  it 'can access the restaurant creation page if logged in and has no previous restaurant' do
    user = create_user
    login_as user
    
    visit new_restaurant_path
    
    expect(page).to have_content 'Criar meu restaurante'
    expect(current_path).to eq new_restaurant_path
    expect(current_path).not_to eq new_user_session_path
  end

  it 'can not access the restaurant creation page if they have a previous restaurant' do
    restaurant = create_restaurant_and_user
    login_as restaurant.user
    
    visit new_restaurant_path
    
    expect(page).not_to have_content 'Criar meu restaurante'
    expect(current_path).not_to eq new_restaurant_path
    expect(current_path).to eq root_path
  end

  it 'sees the restaurant creation page if logged in and has no previous restaurant' do
    user = create_user

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'

    expect(page).to have_content 'Criar meu restaurante'
    expect(current_path).to eq new_restaurant_path
  end

  it 'creates a restaurant with success' do
    user = create_user

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'
    fill_in 'Nome Fantasia', with: 'Pizzaria Campus du Codi'
    fill_in 'Razão Social', with: 'Restaurante Entregas Pizzaria Campus du Codi S.A'
    fill_in 'CNPJ', with: '30.883.175/2481-06'
    fill_in 'Endereço Completo', with: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP'
    fill_in 'Telefone (digite apenas os números)', with: '12987654321'
    fill_in 'E-mail', with: 'campus@ducodi.com.br'
    
    within '#operating-hours' do
      select 'Terça-feira', from: 'Dia da Semana'
      fill_in 'Início do Período', with: '08:00'
      fill_in 'Fim do Período', with: '12:00'
      select 'Aberto', from: 'Status'
    end
    click_on 'Criar Restaurante'

    expect(page).to have_content 'Restaurante criado com sucesso!'
    expect(page).to have_content 'Pizzaria Campus du Codi'
    expect(current_path).to eq root_path
  end

  it 'sees the restaurant item sets page if logged in and has a restaurant' do
    restaurant = create_restaurant_and_user

    login_as restaurant.user

    visit root_path
    expect(page).to have_content "#{restaurant.brand_name} - Cardápios"
    expect(current_path).to eq root_path
  end

  it 'fails to create a restaurant when informing invalid data' do
    user = create_user

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Entrar'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: '0856.98774.931125/00005-82'
    fill_in 'Endereço Completo', with: 'Rua Barão de Codais, 42. Bairro Laranjeiras. CEP: 40.001-002. Santos - SP'
    fill_in 'Telefone (digite apenas os números)', with: '12987654321'
    fill_in 'E-mail', with: 'campus@ducodi.com.br'
    # fill_in 'Horários de Funcionamento', with: ''
    click_on 'Criar Restaurante'

    expect(page).to have_content 'Ops! Erro ao criar Restaurante'
    expect(page).to have_content 'Criar meu restaurante'
    expect(page).to have_content 'primeiro você precisa criar seu restaurante'
    expect(current_path).to eq '/restaurants'
  end

  it 'must have a restaurant before navigating to any page. If it doesnt, it is redirected to creation page' do
    user = create_user
    login_as user

    second_user = User.create!(
        name: 'Jacquin',
        family_name: 'DuFrance',
        registration_number: CPF.generate,
        email: 'ajc@cquin.com',
        password: 'fortissima12'
      )

    restaurant = Restaurant.create!(
      brand_name: 'Boulangerie JQ',
      corporate_name: 'JQ Pães e Bolos Artesanais S.A.',
      registration_number: CNPJ.generate,
      address: 'Rua Paris Elysees, 50. Bairro Dumont. CEP: 55.001-002. Vinhedo - SP',
      phone: '12988774532',
      email: 'atendimento@bjq.com.br',
      user: second_user
    )

    beverage = Beverage.create!(
      name: 'Agua de coco Sócoco',
      description: 'Caixa de 1L. Já vem gelada',
      calories: 150,
      is_alcoholic: false,
      restaurant: restaurant
    )

    dish = Dish.create!(
      name: 'Sufflair',
      description: 'Chocolate Nestle 150g',
      calories: 258,
      restaurant: restaurant
    )

    dish_serving = Serving.create!(
      description: 'Pequena',
      current_price: 35.5,
      servingable: dish
    )

    beverage_serving = Serving.create!(
      description: 'Grande',
      current_price: 35.5,
      servingable: beverage
    )

    tag = Tag.create(name: 'Vegano', restaurant: restaurant)
    item_set = ItemOptionSet.create(name: 'Almoço', restaurant: restaurant)

    pages = list_pages(
      beverage: beverage,
      restaurant: restaurant,
      dish: dish,
      dish_serving: dish_serving,
      beverage_serving: beverage_serving,
      tag: tag,
      item_set: item_set
    )

    pages.each do |page_url|
      visit page_url

      expect(page).to have_content 'Criar meu restaurante'
    end
  end
end