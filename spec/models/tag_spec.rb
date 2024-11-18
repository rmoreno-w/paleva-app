require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a name' do
        tag = Tag.new(name: '')

        is_tag_valid = tag.valid?
        has_tag_errors_on_name = tag.errors.include? :name

        expect(is_tag_valid).to be false
        expect(has_tag_errors_on_name).to be true
      end
    end

    context 'uniqueness' do
      it 'should have a unique name' do
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
        Tag.create!(name: 'Vegana', restaurant: restaurant)
        tag = Tag.new(name: 'Vegana')

        is_tag_valid = tag.valid?
        has_tag_errors_on_name = tag.errors.include? :name

        expect(is_tag_valid).to be false
        expect(has_tag_errors_on_name).to be true
      end
    end
  end
end
