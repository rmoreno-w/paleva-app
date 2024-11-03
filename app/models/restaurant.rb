class Restaurant < ApplicationRecord
  belongs_to :user
  
  has_many :restaurant_operating_hours, inverse_of: :restaurant
  has_many :dishes, inverse_of: :restaurant
  has_many :beverages, inverse_of: :restaurant
  has_many :tags, inverse_of: :restaurant

  accepts_nested_attributes_for :restaurant_operating_hours

  validates :brand_name, :corporate_name, :registration_number, :address, :phone, :email, :code, presence: true
  validates :phone, length: { minimum: 10, maximum: 11 }
  validates :phone, numericality: { only_integer: true }
  validates :user_id, uniqueness: { message: 'já possui um restaurante'}
  validates :code, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'não é um formato de e-mail válido' }
  validate :validate_registration_number_format

  before_validation :ensure_restaurant_has_code, on: :create

  private
  def validate_registration_number_format
    unless CNPJ.valid?(self.registration_number)
      self.errors.add(:registration_number, 'deve ser um número de CNPJ válido')
    end
  end

  def ensure_restaurant_has_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end
