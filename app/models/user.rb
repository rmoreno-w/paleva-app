class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :family_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true
  validate :registration_number_formatting

  enum :role, { owner: 1, staff: 3}, default: :owner

  belongs_to :restaurant, optional: true
  # has_one :restaurant

  validate :single_ownership

  def has_restaurant?
    self.restaurant.present? && self.restaurant.persisted?
  end

  private
  def registration_number_formatting
    unless CPF.valid?(self.registration_number)
      self.errors.add(:registration_number, 'deve ser um número de CPF válido')
    end
  end

  def single_ownership
    if self.restaurant_id && User.find_by(role: :owner, restaurant: self.restaurant)
      self.errors.add(:restaurant_id, 'já tem um dono')
    end
  end
end
