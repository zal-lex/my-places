# frozen_string_literal: true

# rubocop:disable Lint/AssignmentInCondition
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :places, foreign_key: :author_id, dependent: :destroy, inverse_of: :author
  has_many :active_friendships, class_name: 'Friendship',
                                foreign_key: 'user_id', dependent: :destroy, inverse_of: :user
  has_many :following, through: :active_friendships, source: :friend
  has_many :fav_places, foreign_key: :user_id, dependent: :destroy, inverse_of: :user

  attr_accessor :signin
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: %i[facebook]
  validates :name, presence: true, length: { maximum: 60 }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { maximum: 60 }
  validates :age, presence: true, numericality: { only_integer: true,
                                                  greater_than: 0 }
  validates :sex, presence: true, numericality: { only_integer: true,
                                                  less_than_or_equal_to: 3,
                                                  greater_than: 0 }
  mount_uploader :avatar_url, AvatarUploader

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if signin = conditions.delete(:signin)
      where(conditions).find_by(['lower(username) = :value OR lower(email) = :value',
                                 { value: signin.downcase }])
    else
      find_by(conditions)
    end
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

  def self.from_omniauth(auth,
                         _signed_in_resource = nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    if user
    else
      registered_user = User.find_by(email: auth.info.email)

      return registered_user if registered_user

      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        username: auth.extra.raw_info.name,
        sex: 3,
        age: 1,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
    end
    user
  end
end
# rubocop:enable Lint/AssignmentInCondition
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
