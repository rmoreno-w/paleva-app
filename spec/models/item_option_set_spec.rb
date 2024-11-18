require 'rails_helper'

RSpec.describe ItemOptionSet, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        item_set = ItemOptionSet.new(name: '')

        is_item_set_valid = item_set.valid?
        has_item_set_errors_on_name = item_set.errors.include? :name

        expect(is_item_set_valid).to be false
        expect(has_item_set_errors_on_name).to be true
      end
    end

    context 'uniqueness' do
      it 'should have a unique name when creating for the same restaurant' do
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
        ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
        item_set = ItemOptionSet.new(name: 'Almoço', restaurant: restaurant)

        is_item_set_valid = item_set.valid?
        has_item_set_errors_on_name = item_set.errors.include? :name

        expect(is_item_set_valid).to be false
        expect(has_item_set_errors_on_name).to be true
      end

      it 'may have the same name when creating for different restaurants' do
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
        ItemOptionSet.create!(name: 'Almoço', restaurant: restaurant)
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
        item_set = ItemOptionSet.new(name: 'Almoço', restaurant: second_restaurant)

        is_item_set_valid = item_set.valid?
        has_item_set_errors_on_name = item_set.errors.include? :name

        expect(is_item_set_valid).to be true
        expect(has_item_set_errors_on_name).to be false
      end
    end
  end
end
