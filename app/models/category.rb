class Category < ApplicationRecord
  # VALIDATIONS
  validates :name, presence: true, uniqueness: true
end
