class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, uniqueness: true, allow_blank: true
 
  validates :password, presence: true, confirmation: true, length: { in: 6..20 }, on: :create
  validates :password, presence: true, confirmation: true, length: { in: 6..20 }, on: :update, if: :password_digest_changed?
  validates :password_confirmation, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :update, if: :password_digest_changed?

  has_and_belongs_to_many :roles, :join_table => 'users_roles'
  accepts_nested_attributes_for :roles



end
