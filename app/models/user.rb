# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :places, foreign_key: :author_id, dependent: :destroy, inverse_of: :author
  has_many :active_friendships, class_name: 'Friendship',
                                foreign_key: 'user_id', dependent: :destroy, inverse_of: :user
  has_many :following, through: :active_friendships, source: :friend
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
  mount_uploader :avatar_url, AvatarUploader

  def self.find_first_by_auth_conditions(warden_conditions)
    find_by(['lower(username) = :value OR lower(email) = :value', {
              value: warden_conditions[:signin].downcase
            }])
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    if search
      where('username LIKE ? or email LIKE ?', "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end
end
