# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :places, foreign_key: :author_id, dependent: :destroy, inverse_of: :author
  attr_accessor :signin
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 60 }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { maximum: 15 }
  validates :age, presence: true, numericality: { only_integer: true,
                                                  greater_than: 0 }
  validates :sex, presence: true, numericality: { only_integer: true,
                                                  less_than_or_equal_to: 3,
                                                  greater_than: 0 }

  def self.find_first_by_auth_conditions(warden_conditions)
    find_by(['lower(username) = :value OR lower(email) = :value', {
              value: warden_conditions[:signin].downcase
            }])
  end
end
