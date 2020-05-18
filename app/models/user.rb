# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :signin
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 60 }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 15 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sex, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 3, greater_than: 0 }
  validates :avatar_url, presence: true

  def self.find_first_by_auth_conditions(warden_conditions)
    where(['lower(username) = :value OR lower(email) = :value', { value: warden_conditions[:signin].downcase }]).first
  end
end
# rubocop:enable Layout/LineLength
