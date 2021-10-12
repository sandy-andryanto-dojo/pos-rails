class Product < ApplicationRecord

  validates :sku, uniqueness: true, presence: true, on: :create
  validates :sku, uniqueness: true, presence: true, on: :update

  validates :name, uniqueness: true, presence: true, on: :create
  validates :name, uniqueness: true, presence: true, on: :update

  belongs_to :brand, optional: true
  belongs_to :type, optional: true
  belongs_to :supplier, optional: true
  has_and_belongs_to_many :categories, :join_table => 'products_categories'
  accepts_nested_attributes_for :categories
end
