class PreRegistration < ApplicationRecord
  belongs_to :restaurant

  enum :status, { pending: 0, registered: 3 }, default: :pending

  validates :registration_number, :email, presence: true
  validates :registration_number, :email, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  validate :validate_registration_number_with_existing_users, on: :create
  validate :validate_email_with_existing_users, on: :create
  validate :registration_number_formatting
  

  private
  def validate_registration_number_with_existing_users
    self.errors.add(:registration_number, 'deve ser único, já existe um usuário cadastrado com este CPF') if User.find_by(registration_number: self.registration_number)
  end

  def validate_email_with_existing_users
    self.errors.add(:email, 'deve ser único, já existe um usuário cadastrado com este CPF') if User.find_by(email: self.email)
  end

  def registration_number_formatting
    unless CPF.valid?(self.registration_number)
      self.errors.add(:registration_number, 'deve ser um número de CPF válido')
    end
  end
end
