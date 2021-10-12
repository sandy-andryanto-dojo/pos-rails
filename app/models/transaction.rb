class Transaction < ApplicationRecord
  belongs_to :supplier, optional: true
  belongs_to :customer, optional: true
  belongs_to :user, optional: true
end
