class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :family_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true
  validate :registration_number_formatting

  private
  def registration_number_formatting
    unless CPF.valid?(self.registration_number)
      self.errors.add(:registration_number, 'deve ser um número válido')
    end
  end
end
