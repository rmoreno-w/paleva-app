require 'rails_helper'

RSpec.describe PreRegistration, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should have a registration number' do
        # Arrange
        pre_registration = PreRegistration.new(
          registration_number: '',
          email: 'aloisio@email.com',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_registration_number = pre_registration.errors.include? :registration_number

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_registration_number).to be true
      end

      it 'should have an email' do
        # Arrange
        pre_registration = PreRegistration.new(
          registration_number: '08000661110',
          email: '',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_email = pre_registration.errors.include? :email

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_email).to be true
      end
    end

    context '#uniqueness' do
      it 'registration number should be unique' do
        # Arrange
        User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )

        pre_registration = PreRegistration.new(
          registration_number: '08000661110',
          email: 'luan@email.com',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_registration_number = pre_registration.errors.include? :registration_number

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_registration_number).to be true
      end

      it 'email should be unique' do
        # Arrange
        User.create!(
          name: 'Aloisio',
          family_name: 'Silveira',
          registration_number: '08000661110',
          email: 'aloisio@email.com',
          password: 'fortissima12'
        )

        pre_registration = PreRegistration.new(
          registration_number: '08000661110',
          email: 'aloisio@email.com',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_email = pre_registration.errors.include? :email

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_email).to be true
      end
    end

    context '#registration number validity' do
      it 'should match the pattern' do
        pre_registration = PreRegistration.new(
          registration_number: '00000000000',
          email: 'luan@email.com',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_registration_number = pre_registration.errors.include? :registration_number

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_registration_number).to be true
      end
    end

    context '#email number validity' do
      it 'should match the pattern' do
        pre_registration = PreRegistration.new(
          registration_number: CPF.generate,
          email: 'luan@',
        )

        is_pre_registration_valid = pre_registration.valid?
        has_pre_registration_errors_on_email = pre_registration.errors.include? :email

        expect(is_pre_registration_valid).to be false
        expect(has_pre_registration_errors_on_email).to be true
      end
    end
  end
end
