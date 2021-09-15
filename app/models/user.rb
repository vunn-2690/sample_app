class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: {minimum: Settings.length.min_10}
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.max_255},
    format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {minimum: Settings.length.min_10}
  has_secure_password
end
