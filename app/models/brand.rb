class Brand < ApplicationRecord
    validates :name, uniqueness: true, presence: true, on: :create
    validates :name, uniqueness: true, presence: true, on: :update
end
