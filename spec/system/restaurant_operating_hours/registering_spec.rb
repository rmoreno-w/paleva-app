require 'rails_helper'

describe 'User' do
  context 'visits the page to register an operating hour for a restaurant' do
    it 'and should land in the correct page' do
      restaurant = create_restaurant_and_user

      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Criar Horário'
      

      # Assert
      expect(current_path).to eq new_restaurant_restaurant_operating_hour_path(restaurant.id)
      expect(page).to have_content 'Criar Horário de Funcionamento'
    end

    it 'and succeeds' do
      create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Criar Horário'
      
      select 'Terça-feira', from: 'Dia da Semana'
      fill_in 'Início do Período', with: '08:00'
      fill_in 'Fim do Período', with: '12:00'
      select 'Aberto', from: 'Status'
      click_on 'Criar Horário de Funcionamento'
          
      # Assert
      expect(page).to have_content 'Novo horário salvo com sucesso'
      expect(page).to have_content 'Horários de Funcionamento'
      expect(page).to have_content 'Terça-feira - 08:00 às 12:00 - Aberto'
    end

    it 'and fails when informing invalid data' do
      create_restaurant_and_user

      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'aloisio@email.com'
      fill_in 'Senha', with: 'fortissima12'
      click_on 'Entrar'
      click_on 'Criar Horário'
      
      select 'Terça-feira', from: 'Dia da Semana'
      fill_in 'Início do Período', with: ''
      fill_in 'Fim do Período', with: ''
      select 'Aberto', from: 'Status'
      click_on 'Criar Horário de Funcionamento'
          
      # Assert
      expect(current_path).not_to be root_path
      expect(page).to have_content 'Erro ao criar o horário de funcionamento do restaurante'
      expect(page).not_to have_content 'Horários de Funcionamento'
      expect(page).not_to have_content 'Terça-feira - 08:00 às 12:00: Aberto'
    end
  end
end