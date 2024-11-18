require 'rails_helper'

RSpec.describe DishTag, type: :model do
  describe '#valid' do
    context 'uniqueness' do
      it 'should repeat a tag for a dish' do
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
        tag = Tag.create(name: 'Vegano', restaurant: restaurant)

        dish.tags << tag
        dish_tag = DishTag.new(tag_id: tag.id, dish_id: dish.id)
        dish_tag.valid?

        number_of_tags_assigned_to_dish = dish.tags.count
        has_dish_tag_error_on_dish_id = dish_tag.errors.include? :dish_id

        expect(number_of_tags_assigned_to_dish).to eq 1
        expect(has_dish_tag_error_on_dish_id).to eq true
      end
    end
  end
end
